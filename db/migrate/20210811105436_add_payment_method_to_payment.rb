class AddPaymentMethodToPayment < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :payment_method, :string, null:false
  end
end
