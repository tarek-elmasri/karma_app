class InvoicesController < ApplicationController

  before_action :authenticate_user
  before_action :set_invoice , only: [:show, :edit,:update]

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
