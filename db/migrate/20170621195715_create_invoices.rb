class CreateInvoices < ActiveRecord::Migration[5.1]
  def change
    create_table :invoices do |t|
      t.string :customer_id, null: false, references: :customer
      t.integer :year, null: false
      t.integer :month, null: false
      t.float :amount
      t.boolean :invoiced
      t.string :invoice_error
    end

    add_index :invoices, [ :customer_id, :year, :month ], unique: true
  end
end
