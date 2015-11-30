module ApplicationHelper
  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def photo_url_from link
    link.blank? ? image_path("no-avatar.jpg") : link
  end

  def formatted_time
    Time.now.in_time_zone("Pacific Time (US & Canada)")
  end

  def pst_format time
    date, time = time.split("T")
    time = twenty_four_time(time)
    "#{time} #{date}"
  end

  def twenty_four_time time
    hour, minute = time.split(":").map(&:to_i)
    minute = "0" + minute.to_s if minute.to_s.length < 2
    if hour == 0
      "12:#{minute} AM"
    elsif hour == 12
      "12:#{minute} PM"
    elsif hour > 12
      "#{hour - 12}:#{minute} PM"
    else
      "#{hour}:#{minute} AM"
    end
  end
end
