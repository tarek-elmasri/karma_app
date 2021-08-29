class Client < ApplicationRecord
  has_many :invoices
  has_many :charged_persons
  has_many :payments , through: :invoices

  scope :total_sales, -> {joins(:invoices).sum(:value)}
  scope :total_payments, -> {includes(invoices: :payments).sum(:amount)}
  scope :total_invoices_count, -> {joins(:invoices).count(:client_id)}

  #scopes for search
  scope :filter_by_name, -> (name) {where(aq(:name,:matches,name)) }
  scope :filter_by_area, -> (area) {where(aq(:area,:matches,area))}
  scope :filter_by_invoices_in_time_range, -> (date_range) {
    joins(:invoices).where(invoices: {date: date_range[:start_date]..date_range[:end_date]}).group(:id)
  }
  #sql to get clients with paymetns remaining
  def self.filter_by_remaining_balance(trigger=true)
    # invoices_total_value= Invoice.select('sum(invoices.value)').where('invoices.client_id = clients.id').to_sql
    # payments_total_amount = Payment.select('sum(payments.amount)').where('payments.invoice_id = invoices.id').to_sql
    # left_joins(invoices: :payments).where("(#{invoices_total_value}) - (#{payments_total_amount}) > 0 OR ( (#{invoices_total_value}) > 0 AND payments.amount IS NULL)").group(:id)
    where(aq(:remaining_balance,:gt,"0"))
  end


  scope :totals, lambda {
    select(aq(:sales,:sum).as("total_sales"))
    .select(aq(:paid,:sum).as("total_payments"))
    .select(aq(:remaining_balance,:sum).as("total_remaining_balance"))
    .select(aq(:invoices_count,:sum).as("total_invoices_count"))
    .select(aq(:id,:count).as("total_clients_count"))
    .unscope(:order)
    .unscope(:group)
    .to_a
    .first
  }

  scope :search , lambda{ |options|
    instance = self
    instance = instance.filter_by_name(options[:name]) unless options[:name].blank?
    instance = instance.filter_by_area(options[:area]) unless options[:area].blank?
    instance = instance.filter_by_remaining_balance if options[:with_payments_remaining] == "1"
    if options[:with_invoices_in_time_range]=="1" && options[:invoice_start_date].present? && options[:invoice_end_date].present?
      date_range = {:start_date => options[:invoice_start_date].to_date , :end_date => options[:invoice_end_date].to_date } 
      instance = instance.filter_by_invoices_in_time_range(date_range)
    end
    instance= instance.order(:id)
  }
  validates :name, presence: {message: 'الاسم مطلوب'}
  validates :area, presence: {message: 'المنطقة مطلوبة'}


  end
