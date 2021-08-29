class SearchesController < ApplicationController
  before_action :authenticate_user

  def create
      if params[:type] == 'client'
      redirect_to adv_client_search_path(client_search_params)
    elsif
      params[:type] == 'invoice'
      redirect_to adv_invoice_search_path(invoice_search_params)
    end
  end

  def clients_search
    begin
      @clients= Client.search(params)
      @totals = Client.where(id: @clients.ids).totals
    rescue Exception => e 
      redirect_to new_search_path,alert: 'حدث خطا اتناء البحث'
    end
  end

  def invoices_search
    query = Invoice.where(nil)
    filter_invoice_search_params.each do |key,value|
      query = query.public_send("filter_by_#{key}" , value) if value.present?
    end

    @total_sales =0
    @total_payments = 0
    @total_remaining = 0
    @invoices = []

    query.each do |invoice|
      t_payments = invoice.payments.total
      t_remaining = invoice.payments_remaining
      @invoices << {id: invoice.id, number: invoice.number , date: invoice.date, value: invoice.value, total_payments: t_payments, total_remaining: t_remaining}
      @total_sales += invoice.value
      @total_payments += t_payments
      @total_remaining += t_remaining
    end

  end

  def new

  end

  private
  def client_search_params 
    params.permit(:name,:area,:with_payments_remaining,:with_invoices_in_time_range,:invoice_start_date,:invoice_end_date)
  end

  def invoice_search_params
    params.permit(:max_value,:min_value,:start_date,:end_date,:remaining_balance,:number,:client_name,:client_area)
  end

end
