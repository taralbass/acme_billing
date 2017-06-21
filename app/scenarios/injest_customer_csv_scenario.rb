require 'csv'

class InjestCustomerCsvScenario

  # TODO more robust error handling

  attr_reader :csv_filename, :errors

  def initialize(csv_filename:)
    @csv_filename = csv_filename
    @errors = []
  end

  def injest!
    CSV.foreach(csv_filename, headers:true) do |row|
      injest_customer(row.to_hash.symbolize_keys)
    end
  end

  private

  def injest_customer(attrs)
    customer = Customer.where(uuid: attrs[:uuid]).first_or_initialize
    customer.name = attrs[:name]
    customer.email = attrs[:email]
    customer.address = attrs[:address]
    customer.city = attrs[:city]
    customer.state = attrs[:state]
    customer.zip = attrs[:zip]
    customer.injested_at = Time.now.utc

    unless customer.save
      @errors << "Customer #{customer.uuid} had the following errors: #{customer.errors.full_messages.join(", ")}"
    end
  end

end
