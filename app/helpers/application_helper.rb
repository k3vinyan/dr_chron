module ApplicationHelper
  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def get_patients
    patients_data = HTTParty.get('https://drchrono.com/api/patients',
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
    patients_data["results"]
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
