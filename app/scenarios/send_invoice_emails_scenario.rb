class SendInvoiceEmailsScenario
  # NOTE: unrun and untested due to time constraints

  attr_reader :year, :month

  def initialize(year:, month:)
    @year = year
    @month = month
  end

  def send_invoices!
    invoices_to_send.each do |invoice|
      begin
        send_invoice(invoice)
        invoice.update_attributes! invoiced: true
      rescue StandardError => e
        invoice.update_attributes! invoice_error: e.inspect
      end
    end
  end

  private

  def send_invoice(invoice)
    # TODO not implemented yet
    InvoiceMailer.invoice(invoice: invoice).deliver_now
  end

  def invoices_to_send
    Invoice
      .includes(:customer)
      .where(year: year, month: month, invoiced: false).where().not(amount: nil)
  end

end
