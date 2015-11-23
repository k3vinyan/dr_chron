class PatientsController < ApplicationController
  def create
    response = HTTParty.post("https://drchrono.com/api/patients",
      :body => patient_params.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    if request.xhr?
      # required fields to upload photo via #patch
      render json: {
        id: response["id"],
        gender: response["gender"],
        date_of_birth: response["date_of_birth"]
      }
    else
      redirect_to patients_path
    end
  end

  def upload_photo
    response = HTTMultiParty.put("https://drchrono.com/api/patients/#{params['patient_id_photo']}",
      :body => {
        :id => params["patient_id_photo"],
        :gender => params["gender_photo"],
        :date_of_birth => params["dob_photo"],
        :doctor => current_user.doctor_id,
        :patient_photo => params["patient_photo"]
      },
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    redirect_to patient_path(params["patient_id_photo"])
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
      :body => patient_params.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    fail
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
      }
    end
end
