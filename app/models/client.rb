class Client < ApplicationRecord
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

  def self.filter_by_invoices_in_time_range(start_date,end_date) 
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
  end


  def self.search(options)
    instance = self
    instance = instance.filter_by_name(options[:name]) unless options[:name].blank?
    instance = instance.filter_by_area(options[:area]) unless options[:area].blank?
    instance = instance.filter_by_remaining_balance if options[:with_payments_remaining] == "1"

    if options[:invoice_start_date].present? && options[:invoice_end_date].present?
      instance = instance.filter_by_invoices_in_time_range(options[:invoice_start_date] , options[:invoice_end_date])
    end

    instance= instance.order(:id)
  end


#------------------
  # scope :with_totals , lambda {
  #   payments = Payment.arel_table
  #   invoices = Invoice.arel_table
  #   clients = arel_table

  #   payments_with_totals = payments
  #   .project(payments[:invoice_id])
  #   .project(payments[:amount].sum.as("sum_payments"))
  #   .group(payments[:invoice_id])
  #   .as("payments_with_totals")

  #   invoices_with_totals = invoices
  #     .join(payments_with_totals, Arel::Nodes::OuterJoin)
  #     .on(payments_with_totals[:invoice_id].eq(invoices[:id]))
  #     .project(invoices[:client_id])
  #     .project(invoices[:value].sum.as("sum_sales"))
  #     .project(invoices[:id].count.as("counts"))
  #     .project(payments_with_totals[:sum_payments].sum.as("total_payments"))
  #     .group(invoices[:client_id])
  #     .as("invoices_with_totals")

  #   joins(
  #     clients
  #     .join(invoices_with_totals, Arel::Nodes::OuterJoin)
  #     .on(clients[:id].eq(invoices_with_totals[:client_id]))
  #     .join_sources
  #   )
  #   .select_all_columns
  #   .select(invoices_with_totals[:total_payments].sum.as("total_paid"))
  #   .select(invoices_with_totals[:sum_sales].sum.as("total_sales"))
  #   .select(invoices_with_totals[:counts].sum.as("invoices_count"))
  #   .group(:id)
  #   .distinct
  # }


  
  end
