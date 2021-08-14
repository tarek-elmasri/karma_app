class Invoice < ApplicationRecord
  belongs_to :client
  has_many :payments

  scope :clients_list, -> { Client.select(:id,:name).map{|client| [client.name,client.id]}}
  scope :total_payments, -> {Payment.total_amount}
  scope :total_sales, -> { sum(:value)}
  scope :total_payments_remaining, -> {total_sales - total_payments}
  scope :total_count, -> {all.count}


  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}
  
  def total_paid 
    payments.sum(:amount)
  end

  def total_remaining
    value - total_paid
  end

end
