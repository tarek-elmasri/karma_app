class ProductsController < ApplicationController

  before_action :authenticate_user
  before_action :set_product, only: [:edit,:update]

  def index
    @products = Product.all 
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create 
    @product = Product.new(products_params)
    if @product.save 
      redirect_to products_path, notice: 'تم حفظ المنتج بنجاح'
    else
      render :new
    end
  end

  def update
    if @product.update(products_params)
      redirect_to products_path, notice: "تم تحديث المنتج بنجاح"
    else
      render :edit
    end
  end

  private
  def set_product
    @product = Product.find_by(id: params[:id])
    redirect_to products_path, alert: "المنتج المطلوب غير موجود" if @product.blank?
  end

  def products_params
    params.require(:product).permit(:name,:description,:price,:img,:active)
  end
end
