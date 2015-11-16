class AppointmentsController < ApplicationController
  def index
    appointments_data = get_appointments
    @appointments = appointments_data['results']
  end

  private
    def get_appointments
      HTTParty.get("https://drchrono.com/api/appointments?date=#{Time.now.year}",
        :headers => {
          "Authorization" => "Bearer #{current_user.access_token}",
      })
    end
end
