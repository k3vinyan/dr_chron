module ApplicationHelper
  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def formatted_time
    Time.now.in_time_zone("Pacific Time (US & Canada)")
  end
end
