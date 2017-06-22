# README

For this challenge, I coded 4 scenarios in app/scenarios:

* InjestCustomerCsvScenario - includes tests
* GenerateInvoicesScenario
* SendInvoiceEmailsScenario
* GenerateInvoiceReportScenario

After writing tests for the first, I determined I would not have enough time to do tests for all 3 and instead just coded them up to give the idea of how they would be laid out. They can be considered pseudocode in that they were never even run -- I was just trying to get the basics of all the flows out.

Had I had time, I would have also:

* wrapped each scenario in a rake task that could be run from the command line (except for the
  report scenario)
* written the email template for the invoices
* flushed out the tests for the first scenario and written tests for the other ones
* created a UI to see the report
* possibly written a UI to upload the customer CSV
* fix "injest" to "ingest" throughout the project, LOL
* renamed injested_at to last_ingested_at
* in the real world, I would have considered adding cronjobs

Some business/technical details I would definitely want to discuss:

* How should the system determine which months to bill for? I made the assumption that a customer would first be ingested into the system in the month following the their first billing month, and that they would be re-ingested every month thereafter before the invoices were generated. If they weren't, I assumed that no invoice should be created for the previous month. I'm quite uncomfortable with this approach but it seemed the only option given the data provided.
* What are the return values for the API? Does it every return a NULL amount due? If asked for a month for which a customer shouldn't be billed, what will it do?
* Confirm that billing cycles are the first to the last of the month (given the API URL, these seems like it must be true).


## Addendum

Note: I added after mulling over this problem over the course of the evening a bit more.

I would change my approach now by introducing two background jobs using Sidekiq:

* In place of the API lookup directly in GenerateInvoicesScenario, it would enqueue a sidekig job to look up the amount instead (one job per invoice). This job would have a staggered retry. There would also need to be a hook to say "re-enqueue all the invoices that didn't successfully get their amount looked up via the API". This job would also verify that the amount hadn't already been updated on the invoice row before it updated it -- just in case two jobs for the same invoice got enqueued (in theory this shouldn't matter since it would always be the same amount,but I would still add the check). 
* In place of the SendInvoiceEmailsScenario, I would create a sidekiq job to send the invoice email, also with a staggered retry. It would be enqueued by the previous job that looks up the amount from the API if it completes successfully. There would also need to be a hook to re-enqueue all non-delivered invoices for a year and month and invoiced = false. And very importantly, I would implement a lock around the critical section of code that confirms the invoice hadn't been delivered (with either an initial load or reload of the invoice), sends the email, and updates the invoice to a delivered state (via the invoiced flag). I would most likely use a redis lock that was keyed of off customer_id, year and month. This would ensure an invoice is never sent twice.

When I was coding the challenge, I initially considered a sidekig job for just the email portion, but decided against it. I felt it added complexity (since you have to worry multiple jobs for the same invoice), and felt it was sufficient and simpler to write the scenario that could be run multiple times, with each successive run only picking up what hadn't been delivered before. On further consideration, you really have the same problem in that case too, since the scenario could be invoked again before the first run was complete. And furthermore, a job structure is really ideal for the API lookup given its unreliability. So I am now firmly of the opinion that this would be a better approach. It would also scale much better.
