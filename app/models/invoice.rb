class Invoice < ApplicationRecord
  belongs_to :client
  has_many :payments

  scope :total_sales, -> { sum(:value) }
  scope :total_payments, -> {joins(:payments).sum(:amount)}
  scope :total_payments_remaining, -> {total_sales - total_payments}
  scope :with_cash_payments, -> {joins(:payments).where('payments.payment_method = ?', "cash").distinct}
  scope :with_transfer_payments, -> {joins(:payments).where('payments.payment_method = ?', "transfer").distinct}
  #scopes for search
  scope :filter_by_value_range, -> (range) {where(value: range[:min]..range[:max])}
  scope :filter_by_number , -> (number) { where(number: number)}
  scope :filter_by_client_name, -> (name) { joins(:client).where('clients.name LIKE ? AND clients.id = invoices.client_id', "%#{name}%").distinct}
  scope :filter_by_client_area, -> (area) {joins(:client).where("clients.area LIKE ? AND clients.id = invoices.client_id", "%#{area}%").distinct}
  scope :filter_by_in_time_range, -> (date_range) {where(date: date_range[:start_date]..date_range[:end_date])}

  def self.filter_by_remaining_balance(trigger=true)
    left_joins(:payments).where(" ( invoices.value - (SELECT sum(payments.amount) FROM payments WHERE payments.invoice_id = invoices.id)) > 0 OR ( invoices.value > 0 AND payments.amount IS NULL) ").distinct
  end

  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}

  #testing
  scope :h_total_sales, lambda {
    select(Invoice.arel_table[:value].sum.as("total_sales"))
  }
  scope :h_total_payments, lambda {
    joins(:payments).select(Payment.arel_table[:amount].sum.as("total_payments"))
  }
  def payments_remaining
    value - payments.total
  end


end
