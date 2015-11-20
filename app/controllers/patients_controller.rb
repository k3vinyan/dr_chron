class PatientsController < ApplicationController
  def create
    response = HTTParty.post("https://drchrono.com/api/patients_summary",
      :body => {
        :first_name => params["first_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => format_date(params["date"]),
        :doctor => current_user.doctor_id
      }.to_json,
        :headers => {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to patients_path
  end

  def index
    @patients = get_patients
  end

  def show
    @patient = get_patient(params["id"])
  end

  private
    def format_date date
      "#{date['year']}-#{date['month']}-#{date['day']}"
    end
end
