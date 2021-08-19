class Client < ApplicationRecord
  has_many :invoices
  has_many :charged_persons

  #scopes for search
  scope :filter_by_name, -> (name) {where('name LIKE ?' , "%#{name}%") }
  scope :filter_by_area, -> (area) {where('area LIKE ?' , "%#{area}%")}
  scope :filter_by_invoices_in_time_range, -> (date_range) {joins(:invoices).where(invoices: {date: date_range[:start_date]..date_range[:end_date]}).distinct}
  #sql to get clients with paymetns remaining
  def self.filter_by_remaining_balance(trigger=true)
    invoices_total_value= Invoice.select('sum(invoices.value)').where('invoices.client_id = clients.id').to_sql
    payments_total_amount = Payment.select('sum(payments.amount)').where('payments.invoice_id = invoices.id').to_sql
    Client.left_joins(invoices: :payments).where("(#{invoices_total_value}) - (#{payments_total_amount}) > 0 OR ( (#{invoices_total_value}) > 0 AND payments.amount IS NULL)").distinct
  end


  validates :name, presence: {message: 'الاسم مطلوب'}
  validates :area, presence: {message: 'المنطقة مطلوبة'}
  




end
