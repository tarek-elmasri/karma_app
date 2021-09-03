class SearchesController < ApplicationController
  before_action :authenticate_user

  def new
  end
  
  def create
    if params[:type] == 'client'
      redirect_to clients_search_path(client_search_params)
    elsif
      params[:type] == 'invoice'
      redirect_to invoices_path(invoice_search_params)
    else
      redirect_to new_search_path
    end
  end

  private
  def client_search_params 
    options = params.permit(:name,:area,:with_payments_remaining,:invoice_start_date,:invoice_end_date)
    options[:invoices_between]= { start_date: options[:invoice_start_date] , end_date: options[:invoice_end_date]}
    return options
  end

  def invoice_search_params
    options = params.permit(:max_value,:min_value,:start_date,:end_date,:remaining_balance,:number,:client_name,:client_area)
    options[:invoices_between] = {start_date: options[:start_date] , end_date: options[:end_date]}
    options[:value_between] = {min_value: options[:min_value] , max_value: options[:max_value]}
    return options
  end

end
