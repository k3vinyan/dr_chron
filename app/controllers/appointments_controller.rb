class AppointmentsController < ApplicationController
  def index
    appointments_data = get_appointments
    @appointments = appointments_data['results']
  end

  def new
  end

  def create
    response = HTTParty.post("https://drchrono.com/api/appointments",
      :body => {
        :doctor => current_user.doctor_id,
        :duration => params["duration"],
        :patient => params["patient_id"],
        :scheduled_time => format_date(params["date"])
      },
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
      })
    fail
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
      HTTParty.get("https://drchrono.com/api/appointments?date=#{Time.now.year}",
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
      })
    end
end
