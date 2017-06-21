class GenerateInvoiceReportScenario
  # Note: not run or tested due to time constraints

  # Terminology:
  #   prepared: invoice where amount is determined but may or may not have been delivered
  #   delivered: invoice where email was successfully sent
  attr_reader :year, :month

  def initialize(year:, month:)
    @year = year
    @month = month
  end

  def invoice_count
    Invoice.where(year: year, month: month).count
  end

  def prepared_invoice_count
    Invoice.where(year: year, month: month).where().not(amount: nil).count
  end

  def prepared_invoice_sum
    Invoice.where(year: year, month: month).where().not(amount: nil).sum(:amount)
  end

  def delivered_invoice_count
    Invoice.where(year: year, month: month, invoiced: true).count
  end

  def delivered_invoice_sum
    Invoice.where(year: year, month: month, invoiced: true).sum(:amount)
  end

end
