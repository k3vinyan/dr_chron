class PatientsController < ApplicationController
  def create
    response = HTTParty.post('https://drchrono.com/api/patients',
      :body => {
        :gender => "Male",
        :date_of_birth => "1991-04-07",
        :doctor => current_user.doctor_id
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    fail
  end
end
