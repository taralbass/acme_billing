class AddIndexToCustomerInjestedAt < ActiveRecord::Migration[5.1]
  def change
    add_index :customers, :injested_at
  end
end
