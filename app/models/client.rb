class Client < ApplicationRecord
  include Testable
  has_many :invoices
  has_many :charged_persons
  has_many :payments , through: :invoices

  validates :name, presence: {message: 'الاسم مطلوب'}
  validates :area, presence: {message: 'المنطقة مطلوبة'}

  scope :total_sales, -> {joins(:invoices).sum(Invoice.arel_table[:value])}
  scope :total_payments, -> {joins(invoices: :payments).sum(Payment.arel_table[:amount])}
  scope :total_invoices_count, -> {joins(:invoices).count(Invoice.arel_table[:client_id])}
  scope :filter_by_name, -> (name) {where(aq(:name,:matches,"%#{name}%")) }
  scope :filter_by_area, -> (area) {where(aq(:area,:matches,"%#{area}%"))}
  scope :filter_by_remaining_balance, -> {where(aq(:remaining_balance,:gt,"0"))}

  scope :totals, lambda {
    data =  select(aq(:sales,:sum).as("total_sales"))
      .select(aq(:paid,:sum).as("total_payments"))
      .select(aq(:remaining_balance,:sum).as("total_remaining_balance"))
      .select(aq(:invoices_count,:sum).as("total_invoices_count"))
      .select(aq(:id,:count).as("total_clients_count"))
      .unscope(:order)
      .unscope(:group)
      .to_a
      .first

    return {
      sales: data["total_sales"],
      payments: data["total_payments"],
      remaining_balance: data["total_remaining_balance"],
      invoices_count: data["total_invoices_count"],
      clients: data["total_clients_count"]
    }
  }

  scope :filter_by_invoices_in_time_range , lambda { |start_date,end_date| 
    filtered_invoices = Invoice.arel_table
      .project(Invoice.arel_table[:client_id])
      .where(Invoice.arel_table[:date].between(start_date..end_date))
      .group(Invoice.arel_table[:client_id])
      .as("filtered_invoices")

    joins(
      arel_table
      .join(filtered_invoices)
      .on(arel_table[:id].eq(filtered_invoices[:client_id]))
      .join_sources
    )
  }

  #--------------------------------

end
