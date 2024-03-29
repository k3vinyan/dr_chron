class AppointmentsController < ApplicationController
  def index
    @appointments = get_appointments
    @patients = get_patients 

    @appointments.each do |appt|
      appt["patient_info"] = @patients.find {|patient| patient["id"] == appt["patient"]}
    end

    @office_data = get_offices
  end

  def show
    @appointment = get_appointment(params["id"])
    @patient = get_patient(@appointment["patient"])
    @office_data = get_offices
  end

  def create
    # figure out a more efficient way to do this
    if params["patient_id"].blank?
      patients = get_patients
      patient = patients.find do |patient|
        "#{patient["first_name"]} #{patient["last_name"]}" == params["patient"]
      end
      params["patient_id"] = patient["id"]
    end

    response = HTTMultiParty.post("https://drchrono.com/api/appointments",
      :body => appointment_params,
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to appointments_path
  end

  def update
    response = HTTMultiParty.put("https://drchrono.com/api/appointments/#{params['id']}",
      :body => appointment_params,
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",

    })

    redirect_to appointment_path(params["id"])
  end

  def destroy
    response = HTTMultiParty.delete("https://drchrono.com/api/appointments/#{params[:id]}",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
    redirect_to appointments_path
  end

  private
    def appointment_params
      # use rails utc method
      time = twenty_four_time(params["hour"].to_i, params["am_pm"])
      date = format_date(params["date"], time, params["minute"])

      {
        :doctor => current_user.doctor_id,
        :duration => params["duration"],
        :patient => params["patient_id"],
        :office => params["office"].split(" ")[-1].to_i,
        :exam_room => params["exam_room"],
        :reason => params["reason"],
        :scheduled_time => date
      }
    end

    def format_date date, hour, minute 
      hour = hour.to_s.length < 2 ? "0" + hour.to_s : hour.to_s
      "#{date['year']}-#{date['month']}-#{date['day']}T#{hour}:#{minute}:00"
    end

    def twenty_four_time hour, am_pm
      if am_pm == "AM" && hour == 12
        return 0;
      elsif am_pm == "PM" && hour == 12
        return 12;
      elsif am_pm == "PM"
        return hour + 12
      else
        return hour
      end
    end

    def get_appointment id
      HTTMultiParty.get("https://drchrono.com/api/appointments/#{id}",
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
      })
    end
    
end
