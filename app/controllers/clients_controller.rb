class ClientsController < ApplicationController

  before_action :authenticate_user
  before_action :set_client, only: [:show,:edit,:update]
  def index
    @clients = Client.all
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
    redirect_to client_path(id: params[:client][:id])
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
