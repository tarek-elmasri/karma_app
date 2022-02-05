class ApplicationController < ActionController::Base
  
  before_action :set_current_user

  def set_current_user
    puts session[:user]
    if session[:user]
    Current.user = User.find_by(id: session[:user])
    end 
  end

  def authenticate_user
    redirect_to root_path, alert: 'الرجاء تسجيل الدخول' unless Current.user.present?
  end


end
