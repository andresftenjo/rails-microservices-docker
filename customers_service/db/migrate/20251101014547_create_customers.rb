class CreateCustomers < ActiveRecord::Migration[7.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.string :tax_id
      t.string :email
      t.string :address

      t.timestamps
    end
  end
end
