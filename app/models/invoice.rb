class Invoice < ApplicationRecord
  belongs_to :client
  has_many :payments

  scope :total_sales, -> { sum(:value)}
  scope :total_payments, -> {joins(:payments).sum(:amount)}
  scope :total_payments_remaining, -> {total_sales - total_payments}
  scope :with_cash_payments, -> {joins(:payments).where('payments.payment_method = ?', "cash").distinct}
  scope :with_transfer_payments, -> {joins(:payments).where('payments.payment_method = ?', "transfer").distinct}


  #scopes for search
  scope :in_time_range , -> (start_date , end_date) {where(date: start_date..end_date)}
  

  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}


  def payments_remaining
    value - payments.total
  end

end
