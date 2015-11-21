class PatientsController < ApplicationController
  def create
    response = HTTParty.post("https://drchrono.com/api/patients",
      :body => {
        :first_name => params["first_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => format_date(params["date"]),
        :doctor => current_user.doctor_id,
        :address => params["address"],
        :city => params["city"],
        :state => params["state"],
        :zip_code => params["zip_code"],
        :home_phone => params["home_phone"],
        :cell_phone => params["cell_phone"],
        :emergency_contact_name => params["emergency_contact_name"],
        :emergency_contact_phone => params["emergency_contact_phone"],
        :emergency_contact_relation => params["emergency_contact_relation"],
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

  def update
    response = HTTParty.patch("https://drchrono.com/api/patients/#{params['id']}",
      :body => {
        :first_name => params["first_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => format_date(params["date"]),
        :doctor => current_user.doctor_id,
        :address => params["address"],
        :city => params["city"],
        :state => params["state"],
        :copay => params["copay"]
      }.to_json,
        :headers => {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to patient_path(params["id"])
  end

  private
    def format_date date
      "#{date['year']}-#{date['month']}-#{date['day']}"
    end
end
