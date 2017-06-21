require 'rails_helper'

describe InjestCustomerCsvScenario do

  let(:csv_path) { File.join(Rails.root, 'spec', 'test_files', 'customer_csv', 'good.csv') }
  let(:scenario) { InjestCustomerCsvScenario.new(csv_filename: csv_path) }

  subject { scenario.injest! }

  context "new customers" do

    it "creates new customers" do
      expect { subject }.to change { Customer.count }.from(0).to(3)
    end

    it "has no errors" do
      subject
      expect(scenario.errors).to be_empty
    end

    # TODO validate values

  end

  context "customer exists" do

    let!(:buffy) { create(:customer, uuid: "A2B4G60", name: "Buffilina") }

    it "upates existing customer" do
      subject
      expect(buffy.reload.name).to eq('Buffy Summers')
    end

    it "creates new customers" do
      expect { subject }.to change { Customer.count }.from(1).to(3)
    end

  end

  context "customer not in CSV" do

    let(:original_injested_at) { 1.month.ago.change(usec: 0) }
    let(:customer) { create(:customer, injested_at: original_injested_at) }

    it "does not update injested_at for customer not in file" do
      subject
      expect(customer.reload.injested_at).to eq(original_injested_at)
    end

  end

  context "there are errors" do
    let(:csv_path) { File.join(Rails.root, 'spec', 'test_files', 'customer_csv', 'bad.csv') }

    it "creates new customers that are valid" do
      expect { subject }.to change { Customer.count }.from(0).to(2)
    end

    it "has no errors" do
      subject
      expect(scenario.errors.size).to eq(1)
    end
  end

end



