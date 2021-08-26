class Invoice < ApplicationRecord
  # add counter cache after seeding and migrating db
  belongs_to :client , counter_cache: :invoices_count
  has_many :payments

  scope :total_value, -> { sum(:value) }
  scope :total_payments, -> {sum(:paid)}
  scope :total_payments_remaining, -> {total_value - total_payments}
  # scope :with_cash_payments, -> {joins(:payments).where('payments.payment_method = ?', "cash").distinct}
  # scope :with_transfer_payments, -> {joins(:payments).where('payments.payment_method = ?', "transfer").distinct}
  #scopes for search
  scope :filter_by_value_range, -> (range) {where(value: range[:min]..range[:max])}
  scope :filter_by_number , -> (number) { where(number: number)}

  #old scope :filter_by_client_name, -> (name) { joins(:client).where('clients.name LIKE ? AND clients.id = invoices.client_id', "%#{name}%").distinct}
  scope :filter_by_client_name, -> (name) { 
    joins(:client)
    .where(
      Client
      .aq(:name , :matches , name)
      .and(
        aq(:client_id,:eq,Client.arel_table[:id])
      )
    )
    .distinct
  }
  
  #old scope :filter_by_client_area, -> (area) {joins(:client).where("clients.area LIKE ? AND clients.id = invoices.client_id", "%#{area}%").distinct}
  scope :filter_by_client_area, -> (area) {
    joins(:client)
    .where(
      Client
      .aq(:area, :matches , area)
      .and(
        aq(:client_id,:eq, Client.arel_table[:id])
      )
    )
    .distinct
  }
  
  scope :filter_by_in_time_range, -> (date_range) {where(date: date_range[:start_date]..date_range[:end_date])}

  def self.filter_by_remaining_balance(trigger=true)
    left_joins(:payments).where(" ( invoices.value - (SELECT sum(payments.amount) FROM payments WHERE payments.invoice_id = invoices.id)) > 0 OR ( invoices.value > 0 AND payments.amount IS NULL) ").distinct
  end

  validates :number, presence: {message:'رقم الفاتورة مطلوب'}, numericality: {only_integer:true, message: 'رقم الفاتورة يجب ان يكون رقم صحيح'}
  validates :value , presence:{message: 'قيمة الفاتورة مطلوبة'}, numericality: {message: 'قيمة الفاتورة يجب ان تكون رقم'}
  validates :client_id , presence: {message: "العميل مطلوب"}
  validates :date , presence: {message: 'تاريخ الفاتورة مطلوب'}

  after_save :calculate_client_total_sales




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
