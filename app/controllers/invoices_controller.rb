class InvoicesController < ApplicationController

  before_action :authenticate_user
  before_action :set_invoice , only: [:show, :edit,:update]

  has_scope :filter_by_client_name , as: :client_name
  has_scope :filter_by_client_area , as: :client_area
  has_scope :filter_by_number , as: :number
  has_scope :filter_by_remaining_balance , as: :remaining_balance, type: :boolean
  has_scope :filter_by_value_range, as: :value_between , using: %i[min_value max_value] , type: :hash
  has_scope :filter_by_in_time_range , as: :invoices_between , using: %i[start_date end_date], type: :hash
  has_scope :not_full_paid_since 

  include ApplicationHelper
  
  def index
    begin
      @invoices = apply_scopes(Invoice).all
      @totals= @invoices.totals
      @invoices = @invoices.select_all_columns.select_client_name.order(date: :desc)
    rescue Exception => e 
      redirect_to new_search_path,alert: "حدث خطأ أثناء البحث"
    end
  end

  def new
    @invoice= Invoice.new(client_id: params[:client_id] || nil)
  end

  def create
    @invoice = Invoice.new(invoices_params)
    if @invoice.save()
      redirect_to @invoice , notice: 'تم اضافة الفاتورة بنجاح'
    else
      render :new
    end

  end

  def show
    @products= @invoice.invoice_products
  end

  def edit
  end

  def update
    if @invoice.update(invoices_params)
      redirect_to @invoice.client, notice: 'تم تحديث الفاتورة بنجاح'
    else
      render :edit
    end
  end

  private
  def invoices_params
    params.require(:invoice).permit(:client_id,:number,:value,:payment_method,:date,:paid)
  end

  def set_invoice
    @invoice = Invoice.find_by(id: params[:id])
    redirect_to clients_path , alert: 'رقم الفاتورة خاطئ' unless @invoice.present?
  end
end
