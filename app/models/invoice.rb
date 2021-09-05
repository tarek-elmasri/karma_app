class Invoice < ApplicationRecord
  include InvoicesTestable
  belongs_to :client , counter_cache: :invoices_count
  has_many :payments

  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}

  after_save :calculate_client_total_sales

  scope :total_value , lambda { sum(:value)}
  scope :total_paid, lambda { sum(:paid)}
  scope :filter_by_remaining_balance, lambda {where(arel_table[:value].gt(arel_table[:paid]))}
  scope :select_client_name, lambda {joins(:client).select(Client.arel_table[:name])}
  scope :filter_by_value_range , lambda {|min , max| where(value: min..max) }
  scope :filter_by_number , lambda { |number| where(number: number)}
  scope :filter_by_client_name , lambda { |name| 
    joins(:client)
    .where(Client.aq(:name , :matches , "%#{name}%"))  
  }
  scope :filter_by_client_area , lambda { |area| 
    joins(:client)
    .where(Client.aq(:area, :matches , "%#{area}%"))  
  }
  scope :filter_by_in_time_range , lambda { |start_date , end_date|  where(date: start_date..end_date) }
  scope :totals , lambda {
    data= select(aq(:value , :sum).as("total_value"))
    .select(aq(:paid, :sum).as("total_payments"))
    .unscope(:order)
    .unscope(:group)
    .to_a
    .first

    return {
      value: data["total_value"],
      payments: data["total_payments"],
      remaining_balance: (data["total_value"] || 0.0) - (data["total_payments"] || 0.0)
    }
  }

  #---------------------------------------------
  def payments_remaining
    value - payments.total
  end

  def calculate_client_total_sales
    client.update({
      sales: client.invoices.sum(:value) ,
      remaining_balance: (client.invoices.sum(:value) - client.invoices.joins(:payments).sum(:amount)),
      paid: client.invoices.joins(:payments).sum(:amount)
      })
  end

end
