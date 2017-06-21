class GenerateInvoicesScenario
  # Note: this class is unrun/untested due to time constraints

  # TODO: validate how to determine what invoices should be generated
  # IDEAL: external validation of what months to generate invoices for instead of
  #   determining it based on when they were injested. Could be a field in the CSV
  #   or based on response from API.
  # ASSUMPTIONS
  #   * customers will first be created in month following their first month of service
  #     e.g. customer created in April 2017 can be invoiced for March 2017 but not Feb 2017
  #   * customers should only be invoiced if they were injested in month following month
  #     of bill
  #     e.g. customer last injested in April 2017 can be invoice for March 2017 and before,
  #          but if they were last injested March 2017, don't generate March 2017 invoice

  # TODO: how to handle customers that leave and return

  # http://api.acme.fake/due/{UUID}/{MONTH}/{YEAR}
  # Response: { "amount_due": { DECIMAL_VALUE} }
  API_URL = "http://api.acme.fake/due"

  attr_reader :year, :month, :billing_first_of_next_month, :invoicing_first_of_month, :http_client

  def initialize(year:, month:)
    @year = year
    @month = month
    @billing_first_of_month = Date.parse("#{year}#{month}01").at_beginning_of_month
    @invoicing_first_of_month = billing_first_of_month.next_month
    @http_client = HTTPClient.new
  end

  def generate_invoices!
    validate_month_is_complete
    generate_invoices
    fetch_amounts
  end

  private

  def validate_month_is_complete
    this_month = Date.today.at_beginning_of_month

    unless this_month > first_of_month
      raise Exception.new("Can't generate invoices until the following month")
    end
  end

  def generate_invoices
    (target_customer_ids - existing_invoice_customer_ids).each do |customer_id|
      Invoice.create! year: year, month: month, customer_id: customer_id
    end
  end

  def fetch_amounts
    Invoice.includes(:customer).where(
      year: year,
      month: month,
      amount: nil
    ).each do |invoice|
      begin
        invoice.update_attributes! amount: fetch_amount(invoice)
      rescue StandardError => e
        invoice.update_attributes! invoice_error: e.inspect
      end
    end
  end

  # TODO: better error handling
  # TODO: does API return NULL for amount and if so what does that mean?
  def fetch_amount(invoice)
    response = http_client.get(api_url_for(invoice))
    unless response.status == 200
      raise Exception.new("HTTP status of API call to get amount: #{response.status}")
    end
    JSON.parse(response.content)["amount_due"]
  end

  # http://api.acme.fake/due/{UUID}/{MONTH}/{YEAR}
  def api_url_for(invoice)
    "#{API_URL}/#{invoice.uuid}/#{month}/#{year}"
  end

  def target_customer_ids
    creation_cutoff = @invoicing_first_of_month.next_month
    injestion_cutoff = @invoicing_first_of_month

    Customer.where(
      "created_at < :creation_cutoff and injested_at >= injestion_cutoff",
      { creation_cutoff: creation_cutoff, injestion_cutoff: injestion_cutoff }
    ).pluck(:id)
  end

  def existing_invoice_customer_ids
    Invoice.where(
      year: year,
      month: month
    ).pluck(:customer_id)
  end

end
