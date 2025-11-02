class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.integer :customer_id
      t.decimal :amount
      t.date :issued_on
      t.text :notes

      t.timestamps
    end
  end
end
