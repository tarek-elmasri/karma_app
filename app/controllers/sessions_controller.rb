class SessionsController < ApplicationController
  before_action :check_current_session , except: [:destroy]

  def log_in
    @user = User.new
  end

  def sign_in 
    @user = User.find_by(email: params[:user][:email])
    if @user&.authenticate(params[:user][:password])
      session[:user_id] = @user.id 
      Current.user = @user
      redirect_to clients_path , notice: "تم تسجيل دخولك بنجاح #{@user.name}"
    else
      redirect_to root_path, alert: 'البريد الالكتروني او كلمة المرور غير صحيحة'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'تم تسجيل الخروج بنجاح'
  end

  def check_current_session
    if Current.user.present?
      redirect_to clients_path
    end
  end

end
