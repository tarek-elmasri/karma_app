class Client < ApplicationRecord
  has_many :invoices
  has_many :charged_persons

  validates :name, presence: {message: 'الاسم مطلوب'}
  validates :area, presence: {message: 'المنطقة مطلوبة'}
  

  # search methods
  def self.by_area(area)
    return self if area.blank?
    where('area LIKE ?' , "%#{area}%") 
  end

  def self.by_name(name)
    return self if name.blank?
    where('name LIKE ?' , "%#{name}%") 
  end

  #sql to get clients with paymetns remaining
  def self.have_remaining_balance(trigger=true)
    return self unless trigger
    invoices_total_value= Invoice.select('sum(invoices.value)').where('invoices.client_id = clients.id').to_sql
    payments_total_amount = Payment.select('sum(payments.amount)').where('payments.invoice_id = invoices.id').to_sql
    Client.left_joins(invoices: :payments).where("(#{invoices_total_value}) - (#{payments_total_amount}) > 0 OR ( (#{invoices_total_value}) > 0 AND payments.amount IS NULL)").distinct
  end

end
