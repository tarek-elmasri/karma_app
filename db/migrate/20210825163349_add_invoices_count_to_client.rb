class AddInvoicesCountToClient < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :invoices_count, :integer, default: 0
  end
end
