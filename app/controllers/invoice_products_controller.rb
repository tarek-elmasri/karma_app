class InvoiceProductsController < ApplicationController
  include InvoicesHelper
  
  before_action :authenticate_user
  before_action :set_invoice_product , only: [:update,:edit,:destroy]
  before_action :set_invoice
  before_action :check_current_products_value, only: [:new, :create]

  def index
  end

  def new
    @invoice_product = InvoiceProduct.new(invoice_id: params[:invoice_id])
  end

  def create 
    @invoice_product = @invoice.invoice_products.new(invoice_product_params)
    if @invoice_product.save
      redirect_to invoice_path(@invoice), notice: "تم اضافة المنتج بنجاح"
    else
      render :new , invoice_id: @invoice.id
    end

  end

  def edit
  end

  def update
    if @invoice_product.update(invoice_product_params)
      redirect_to invoice_path(@invoice),notice: "تم تحديث المنتج بنجاح"
    else
      render :edit , invoice_id: @invoice.id
    end
  end

  def destroy
    if @invoice_product.delete
      flash[:notice] = "تم حذف المنتج من الفاتورة بنجاح"
    else
      alert[:alert] = "خطأ أثناء حذف المنتج من الفاتورة."
    end
    redirect_to invoice_path(@invoice)
  end

  private
  def set_invoice_product
    @invoice_product = InvoiceProduct.find_by(id: params[:id])
    redirect_to invoices_path,alert: "خطا" if @invoice_product.blank?
  end

  def set_invoice 
    @invoice = Invoice.find_by(id: params[:invoice_id])
    redirect_to main_path, alert: "خطأ" if @invoice.blank?
  end

  def invoice_product_params
    params.require(:invoice_product).permit(:product_id,:quantity)
  end

  def check_current_products_value
    redirect_to @invoice,alert: "قيمة المنتجات تتوافق مع قيمة الفاتورة الحالية" if invoice_value_matches_products_value?(@invoice)
  end
end
