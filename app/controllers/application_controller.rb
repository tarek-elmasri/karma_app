class ApplicationController < ActionController::Base
  
  before_action :set_current_user

  def set_current_user
    puts session[:user_id]
    if session[:user_id]
    Current.user = User.find_by(id: session[:user_id])
    end 
  end

  def authenticate_user
    redirect_to root_path, alert: 'الرجاء تسجيل الدخول' unless Current.user.present?
  end

end
