class PatientsController < ApplicationController
  def create
    response = HTTParty.post('https://drchrono.com/api/patients',
      :body => {
        :first_name => params["first_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => params["date_of_birth"],
        :doctor => current_user.doctor_id
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    fail
  end
end
