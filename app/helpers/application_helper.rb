module ApplicationHelper
  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end
end
