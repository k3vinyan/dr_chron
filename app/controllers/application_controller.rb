class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def current_user
    @user || @user = User.where(id: session[:user_id]).first
  end

  def get_patient id
    HTTMultiParty.get("https://drchrono.com/api/patients/#{id}",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })
  end

  def get_patients
    HTTMultiParty.get('https://drchrono.com/api/patients',
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })["results"]
  end

  def get_appointments patient_id=nil
    query = patient_id ? "&patient=#{patient_id}" : ""
    HTTMultiParty.get("https://drchrono.com/api/appointments?date_range=#{date_range}#{query}",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })["results"]
  end

  def get_offices
    offices = HTTMultiParty.get("https://drchrono.com/api/offices",
      :headers => {
        "Authorization" => "Bearer #{current_user.access_token}",
    })["results"]

    {
      "offices" => offices,
      "office_names" => offices.map {|office| "#{office['name']} : #{office['id']}"},
      "exam_rooms" => offices[0]["exam_rooms"].map{|room| room["index"]}
    }
  end

  def date_range
    # possibly turn this into a slider UI
    start = Time.now.to_s.split(" ")[0]
    stop = (Time.now + 189 * 86400).to_s.split(" ")[0]
    "#{start}/#{stop}"
  end
end
