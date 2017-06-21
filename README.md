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
