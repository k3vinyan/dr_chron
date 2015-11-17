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
        :scheduled_time => format_date(params["date"], params["time"].first[0]),
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

    def format_date date, time
      "#{date['year']}-#{date['month']}-#{date['day']} #{time.match(/ (\d{2}:\d{2}:\d{2}) /)[1]}"
    end

    def date_range
      # possibly turn this into a slider UI
      start = Time.now.to_s.split(" ")[0]
      stop = (Time.now + 189 * 86400).to_s.split(" ")[0]
      "#{start}/#{stop}"
    end
end
