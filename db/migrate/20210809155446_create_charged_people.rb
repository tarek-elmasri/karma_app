class CreateChargedPeople < ActiveRecord::Migration[6.0]
  def change
    create_table :charged_people do |t|
      t.belongs_to :client, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :phone, null: false

      t.timestamps
    end
  end
end
