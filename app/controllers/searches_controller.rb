class SearchesController < ApplicationController

  def create
    options = params.permit(:type,:name,:area,:with_payments_remaining,:with_invoices_in_time_range,:invoice_start_date,:invoice_end_date)
    if params[:type] == 'client'
      redirect_to adv_client_search_path(options)
    elsif
      params[:type] == 'invoice'
    end
  end

  def clients_search
    @clients= Client.where(nil)
    filter_search_params.each do |key,value|
      @clients = @clients.public_send("filter_by_#{key}" , value) if value.present?
    end
  end

  def new

  end

  private
  def filter_search_params
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
end
