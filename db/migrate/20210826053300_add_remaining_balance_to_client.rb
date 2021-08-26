class AddRemainingBalanceToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :remaining_balance, :float, default: 0
  end
end
