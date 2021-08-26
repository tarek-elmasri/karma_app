class AddPaidToInvoice < ActiveRecord::Migration[6.0]
  def change
    add_column :invoices, :paid, :float, default: 0
  end
end
