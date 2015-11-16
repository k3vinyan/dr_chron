class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def format_date date
    "#{date['year']}-#{date['month']}-#{date['day']}"
  end
end
