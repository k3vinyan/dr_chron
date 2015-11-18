class AppointmentsController < ApplicationController
  def index
    appointments_data = get_appointments
    @appointments = appointments_data['results']

    @patients = get_patients 
    @appointments.each do |appt|
      appt["patient_info"] = @patients.find {|patient| patient["id"] == appt["patient"]}
    end

    get_offices
  end

  def new
    get_offices
  end

  def create
    if params["patient_id"].blank?
      patients = get_patients
      patient = patients.find do |patient|
        "#{patient["first_name"]} #{patient["last_name"]}" == params["patient"]
      end
      params["patient_id"] = patient["id"]
    end

    time = twenty_four_time({hour: params["hour"].to_i, am_pm: params["am_pm"]})
    date = format_date(params["date"], time, params["minute"])

    response = HTTParty.post("https://drchrono.com/api/appointments",
      :body => {
        :doctor => current_user.doctor_id,
        :duration => params["duration"],
        :patient => params["patient_id"],
        :office => params["office"].split(" ")[-1].to_i,
        :exam_room => params["exam_room"],
        :reason => params["reason"],
        :scheduled_time => date
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

    def get_patients
      patients_data = HTTParty.get('https://drchrono.com/api/patients',
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
      })
      patients_data["results"]
    end

    def format_date date, hour, minute 
      hour = hour.to_s.length < 2 ? "0" + hour.to_s : hour.to_s
      stuff = "#{date['year']}-#{date['month']}-#{date['day']}T#{hour}:#{minute}:00"
    end

    def get_offices
      offices_data = HTTParty.get("https://drchrono.com/api/offices",
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
        })

      @offices = offices_data['results']
      @office_names = @offices.map {|office| "#{office['name']} : #{office['id']}"}
      @exam_rooms = @offices[0]["exam_rooms"].map{|room| room["index"]}
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
