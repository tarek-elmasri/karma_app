class PaymentsController < ApplicationController
  before_action :authenticate_user
  before_action :set_invoice, only: [:new,:show]
  before_action :set_payment, only: [:destroy, :edit, :update]

  def new 
    @payment= Payment.new(invoice_id: @invoice.id)
  end

  def show 
  end

  def destroy
    invoice = @payment.invoice
    if @payment.delete 
      flash[:notice]= 'تم حذف السداد بنجاح'
    else
      falsh[:alert]= 'خطا اثناء حذف سداد'
    end

    redirect_to invoice
  end

  def create 
    @payment = Payment.new(payments_params)
    if @payment.save
      redirect_to @payment.invoice, notice: 'تم اضافة السداد بنجاح'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @payment.update(payments_params)
      redirect_to @payment.invoice, notice: 'تم تحديث معلومات السداد بنجاح'
    else
      render :edit
    end
  end

  private

  def payments_params
    params.require(:payment).permit(:invoice_id,:amount,:payment_method,:date)
  end

  def set_invoice 
    @invoice = Invoice.find_by(id: params[:invoice_id])
    redirect_to clients_path , alert: 'الفاتورة المطلوبة غير صحيحة' unless @invoice.present?
  end

  def set_payment
    @payment= Payment.find_by(id: params[:id])
    redirect_to clients_path , alert: 'رقم السداد غير صحيح' unless @payment.present?
  end
end
