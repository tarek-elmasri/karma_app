class SearchesController < ApplicationController

  def create
      if params[:type] == 'client'
      redirect_to adv_client_search_path(client_search_params)
    elsif
      params[:type] == 'invoice'
      redirect_to adv_invoice_search_path(invoice_search_params)
    end
  end

  def clients_search
    query= Client.where(nil)
    filter_client_search_params.each do |key,value|
      query = query.public_send("filter_by_#{key}" , value) if value.present?
    end

    @clients = []
    @total_invoices_count = 0
    @total_sales = 0
    @total_payments = 0
    @total_payments_remaining = 0
    query.each do |client|
      t_count = client.invoices.count
      t_total_sales= client.invoices.total_sales
      t_total_payments = client.invoices.total_payments
      t_total_payments_remaining = client.invoices.total_payments_remaining
      @clients << {id: client.id, area: client.area,invoices_count: t_count, total_sales:  t_total_sales,total_payments: t_total_payments,total_payments_remaining: t_total_payments_remaining }
      @total_invoices_count += t_count
      @total_sales += t_total_sales
      @total_payments += t_total_payments
      @total_payments_remaining += t_total_payments_remaining
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

  def filter_client_search_params
    with_payments_remaining = "" 
    with_payments_remaining = true if params[:with_payments_remaining]=="1"
    date_range=nil
    if params[:with_invoices_in_time_range]=="1" && params[:invoice_start_date].present? && params[:invoice_end_date].present?
      date_range = {:start_date => params[:invoice_start_date].to_date , :end_date => params[:invoice_end_date].to_date } 
    end
    searchOptions = {
                      name: params[:name],
                      area: params[:area] ,
                      remaining_balance: with_payments_remaining,
                      invoices_in_time_range: date_range
                    }

    searchOptions.slice(:name,:area,:remaining_balance, :invoices_in_time_range)
  end

  def filter_invoice_search_params
    remaining_balance=""
    remaining_balance = true if params[:remaining_balance]=="1"

    in_time_range=nil
    if params[:start_date].present? && params[:end_date].present?
      in_time_range={start_date: params[:start_date] , end_date: params[:end_date]}
    end

    value_range=nil
    if params[:max_value].present? && params[:min_value].present?
      value_range = {min: params[:min_value], max: params[:max_value]}  
    end

    searchOptions = {
                      number: params[:number],
                      client_name: params[:client_name],
                      client_area: params[:client_area],
                      remaining_balance: remaining_balance,
                      in_time_range: in_time_range,
                      value_range: value_range
                    }
    
    searchOptions.slice(:number,:client_name,:client_area,:remaining_balance,:in_time_range,:value_range)
  end
end
