class ChargedPersonsController < ApplicationController
  before_action :authenticate_user
  before_action :set_charged_person , only: [:destroy]

  def create
    charged_person= ChargedPerson.new(charged_persons_params)
    
    if charged_person.save
      flash[:notice] =  "تم اضافة الشخص بنجاح"
    else
      flash[:alert] = "خطأ أثناء اضافة شخص مسؤول ، الاسم مطلوب و رقم الهاتف يجب ان يكون خالي من الاحرف"
    end
    redirect_to client_path(id: charged_person.client_id)
  end

  def destroy 
      client = @charged_person.client
      if @charged_person.destroy
        flash[:notice]= 'تم حذف الشخص المسؤول بنجاح'
      else
        flash[:alert] = 'خطأ أثناء حذف الشخص المسؤول'
      end

      redirect_to client_path(client)
  end


  private 
  def charged_persons_params
    params.require(:charged_person).permit(:client_id,:name,:phone,:title)
  end

  def set_charged_person 
    @charged_person = ChargedPerson.find_by(id: params[:id])
    redirect_to clients_path, alert: 'الشخص المسؤول غير موجود' unless @charged_person.present?
  end
end
