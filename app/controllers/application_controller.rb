class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def get_patient id
    swag = HTTParty.get("https://drchrono.com/api/patients/#{params['id']}",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
  end

  def get_patients
    patients_data = HTTParty.get('https://drchrono.com/api/patients',
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
    patients_data["results"]
  end
end
