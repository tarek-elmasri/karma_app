class AddPaidToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :paid, :float, default: 0
  end
end
