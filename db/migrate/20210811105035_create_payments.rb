class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.float :amount, null:false
      t.belongs_to :invoice, null: false, foreign_key: true
      t.date :date , null: false

      t.timestamps
    end
  end
end
