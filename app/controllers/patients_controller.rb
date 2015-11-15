class PatientsController < ApplicationController
  def create
    response = HTTParty.post('https://drchrono.com/api/patients',
      :body => {
        :first_name => params["first_name"],
        :middle_name => params["middle_name"],
        :last_name => params["last_name"],
        :gender => params["gender"],
        :date_of_birth => format_date(params["date"]),
        :doctor => current_user.doctor_id
      }.to_json,
      :headers => {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{current_user.access_token}",
    })

    fail
  end

  private
    def format_date date
      "#{date['year']}-#{date['month']}-#{date['day']}"
    end
end
