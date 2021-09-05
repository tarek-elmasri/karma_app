class ClientsController < ApplicationController

  before_action :authenticate_user
  before_action :set_client, only: [:show,:edit,:update]

  has_scope :filter_by_name , as: :name
  has_scope :filter_by_area , as: :area
  has_scope :filter_by_remaining_balance , as: :with_payments_remaining , type: :boolean
  has_scope :filter_by_invoices_in_time_range, as: :invoices_between, using: %i[start_date end_date ] , type: :hash
  has_scope :where_ids_in, as: :ids, type: :array


  def index
    @clients = Client.order(:id)
    @totals = @clients.totals
  end

  def create
    @client = Client.new(clients_params)
    
    if @client.save()
      redirect_to @client, notice: "تم اضافة العميل بنجاح"
    else
      render :new 
    end
  end

  def search 
    begin
      @clients= apply_scopes(Client).all.order(:id)
      @totals = @clients.totals
    rescue Exception => e
      redirect_to new_search_path, alert: "حدث خطأ أثناء البحث"
    end
  end
  
  
  def new
    @client = Client.new
  end

  def show
  end

  def edit
  end

  def update
    if @client.update(clients_params)
      redirect_to @client , notice: 'تم تحديث العميل بنجاح'
    else
      render :edit
    end
  end

  private
  def clients_params
    params.require(:client).permit(:name,:area)
  end

  def set_client
      @client = Client.find_by(id: params[:id])
      redirect_to clients_path, alert: 'رقم العميل غير صحيح' unless @client.present?
  end
end
