class AppointmentsController < ApplicationController
  def index
    appointments_data = get_appointments
    @appointments = appointments_data['results']
  end

  def new
    offices_data = HTTParty.get("https://drchrono.com/api/offices",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
      })

    @offices = offices_data['results']
    @office_names = @offices.map {|office| "#{office['name']} : #{office['id']}"}
    @exam_rooms = @offices[0]["exam_rooms"].map{|room| room["index"]}
  end

  def create
    response = HTTParty.post("https://drchrono.com/api/appointments",
      :body => {
        :doctor => current_user.doctor_id,
        :duration => params["duration"],
        :patient => params["patient_id"],
        :office => params["office"].split(" ")[-1].to_i,
        :exam_room => params["exam_room"],
        :reason => params["reason"],
        # fix this
        :scheduled_time => format_date(params["date"], twenty_four_time(format_time), params["minute"]),
      },
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to appointments_path
  end

  def destroy
    response = HTTParty.delete("https://drchrono.com/api/appointments/#{params[:id]}",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
    redirect_to appointments_path
  end

  private
    def get_appointments
      HTTParty.get("https://drchrono.com/api/appointments?date_range=#{date_range}",
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
      })
    end

    def format_date date, hour, minute 
      hour = hour.to_s.length < 2 ? "0" + hour.to_s : hour.to_s
      stuff = "#{date['year']}-#{date['month']}-#{date['day']}T#{hour}:#{minute}:00"
    end

    def format_time
      am_pm = params[:am_pm]
      hour = params[:hour].to_i
      if am_pm == "AM" && hour < 4
        {hour: hour + 8, am_pm: "AM"}
      elsif am_pm == "AM" && hour < 5
        {hour: hour + 8, am_pm: "PM"}
      elsif am_pm == "AM" && hour == 12
        {hour: hour - 4, am_pm: "AM"}
      elsif am_pm == "AM" && hour >= 5
        {hour: hour - 4, am_pm: "PM"}
      elsif am_pm == "PM" && hour == 12
        {hour: hour - 4, am_pm: "PM"}
      elsif am_pm == "PM" && hour < 4
        {hour: hour + 8, am_pm: "PM"}
      else
        {hour: hour - 4, am_pm: "AM"}
      end
    end

    def twenty_four_time time
      if time[:am_pm] == "AM" && time[:hour] == 12
        return 0;
      elsif time[:am_pm] == "PM" && time[:hour] == 12
        return 12;
      elsif time[:am_pm] == "PM"
        return time[:hour] + 12
      else
        return time[:hour]
      end
    end
    
    def date_range
      # possibly turn this into a slider UI
      start = Time.now.to_s.split(" ")[0]
      stop = (Time.now + 189 * 86400).to_s.split(" ")[0]
      "#{start}/#{stop}"
    end
end
