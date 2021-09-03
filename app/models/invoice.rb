class Invoice < ApplicationRecord
  
  belongs_to :client , counter_cache: :invoices_count
  has_many :payments

  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}

  after_save :calculate_client_total_sales

  scope :filter_by_remaining_balance, lambda {where(arel_table[:value].gt(arel_table[:paid]))}
  scope :select_client_name, lambda {joins(:client).select(Client.arel_table[:name])}

  def self.filter_by_value_range(range) 
    where(value: range[:min]..range[:max])
  end

  def self.filter_by_number(number) 
    where(number: number)
  end

  def self.filter_by_client_name(name) 
    joins(:client)
    .where(Client.aq(:name , :matches , "%#{name}%"))
  end
  
  def self.filter_by_client_area(area)
    joins(:client)
    .where(Client.aq(:area, :matches , "%#{area}%"))
  end
  
  def self.filter_by_in_time_range(date_range) 
    where(date: date_range[:start_date]..date_range[:end_date])
  end

  def self.search(options)
    instance = self
    instance = instance.filter_by_client_name(options[:client_name]) unless options[:client_name].blank?
    instance = instance.filter_by_client_area(options[:client_area]) unless options[:client_area].blank?
    instance = instance.filter_by_number(options[:number]) unless options[:number].blank?
    instance = instance.filter_by_remaining_balance unless options[:remaining_balance] == "0"
    
    if options[:min_value].present? && options[:max_value].present?
      instance = instance.filter_by_value_range({min: options[:min_value] , max: options[:max_value]})
    end

    if options[:start_date].present? && options[:end_date].present?
      instance = instance.filter_by_in_time_range({start_date: options[:start_date].to_date , end_date: options[:end_date].to_date})
    end

    return instance
  end

  def self.totals 
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
  end

  #scopes for search
  # scope :total_value, -> { sum(:value) }
  # scope :total_payments, -> {sum(:paid)}
  # scope :total_payments_remaining, -> {total_value - total_payments}
  # scope :with_cash_payments, -> {joins(:payments).where('payments.payment_method = ?', "cash").distinct}
  # scope :with_transfer_payments, -> {joins(:payments).where('payments.payment_method = ?', "transfer").distinct}


  def payments_remaining
    value - payments.total
  end

  def calculate_client_total_sales
    client.update({
      sales: client.invoices.total_value ,
      remaining_balance: (client.invoices.sum(:value) - client.invoices.joins(:payments).sum(:amount)),
      paid: client.invoices.joins(:payments).sum(:amount)
      })
  end

end
