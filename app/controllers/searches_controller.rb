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
      @totals = @clients.totals
    rescue Exception => e 
      redirect_to new_search_path,alert: 'حدث خطا اتناء البحث'
    end
  end

  def invoices_search
    begin
      @invoices = Invoice.search(params)
      @totals = @invoices.totals
      @invoices = @invoices.select_all_columns.select_client_name
    rescue Exception => e 
      redirect_to new_search_path,alert: 'حدث خطا اتناء البحث'
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
