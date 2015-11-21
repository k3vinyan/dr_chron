class PatientsController < ApplicationController
  def create
    response = HTTParty.post("https://drchrono.com/api/patients",
      :body => patient_params,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to patients_path
  end

  def search
    fail
  end

  def index
    @patients = get_patients
  end

  def show
    @patient = get_patient(params["id"])
    @patient["appointments"] = get_appointments(@patient["id"])

    @office_data = get_offices
  end

  def update
    response = HTTParty.patch("https://drchrono.com/api/patients/#{params['id']}",
      :body => patient_params,
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

    def patient_params
      {
        :first_name => params["first_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => format_date(params["date"]),
        :doctor => current_user.doctor_id,
        :address => params["address"],
        :city => params["city"],
        :state => params["state"],
        :copay => params["copay"],
        :zip_code => params["zip_code"],
        :home_phone => params["home_phone"],
        :cell_phone => params["cell_phone"],
        :emergency_contact_name => params["emergency_contact_name"],
        :emergency_contact_phone => params["emergency_contact_phone"],
        :emergency_contact_relation => params["emergency_contact_relation"],
        :employer => params["employer"],
        :employer_address => params["employer_address"],
        :employer_city => params["employer_city"],
        :employer_state => params["employer_state"],
        :employer_zip_code => params["employer_zip_code"],
      }.to_json
    end
end
