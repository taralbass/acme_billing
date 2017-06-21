class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :uuid, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :address, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip, null: false
      t.datetime :injested_at
      t.timestamps
    end

    add_index :customers, :uuid, unique: true
  end
end
