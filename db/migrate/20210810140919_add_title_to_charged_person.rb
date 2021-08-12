class AddTitleToChargedPerson < ActiveRecord::Migration[6.0]
  def change
    add_column :charged_people, :title, :string
  end
end
