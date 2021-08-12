class CreateInvoices < ActiveRecord::Migration[6.0]
  def change
    create_table :invoices do |t|
      t.belongs_to :client, null: false, foreign_key: true
      t.integer :number , null:false
      t.float :value, null:false
      t.date :date
      t.timestamps
    end
  end
end
