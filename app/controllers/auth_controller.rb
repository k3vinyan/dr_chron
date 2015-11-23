class AuthController < ApplicationController
  def authenticate
    redirect_to "https://drchrono.com/o/authorize/?redirect_uri=#{ENV['REDIRECT_URI']}&response_type=code&client_id=#{ENV['CLIENT_ID']}"
  end

  def authorize
    auth_data = post_token_code
    user_data = get_auth_token(auth_data['access_token'])

    find_or_create_user(auth_data, user_data)

    session[:user_id] = @user.id
    redirect_to root_path
  end

  def signout
    session[:user_id] = nil
    redirect_to root_path
  end


  private
    def post_token_code
      HTTMultiParty.post('https://drchrono.com/o/token/',
        :body => {
          :code             => params[:code],
          :grant_type       => 'authorization_code',
          :redirect_uri     => ENV['REDIRECT_URI'],
          :client_id        => ENV['CLIENT_ID'],
          :client_secret    => ENV['CLIENT_SECRET']
      })
    end

    def get_auth_token access_token
      HTTMultiParty.get('https://drchrono.com/api/users/current',
        :headers => {
          'Authorization' => "Bearer #{access_token}",
      })
    end

    def find_or_create_user auth_data, user_data
      @user = User.where(username: user_data['username']).first

      unless @user
        @user = User.new(
          username: user_data['username'],
          # not currently utilizing this
          refresh_token: auth_data['refresh_token'])
        if user_data['is_doctor']
          @user.doctor_id = user_data['doctor']
        end
      end  

      @user.access_token = auth_data['access_token']
      @user.save
    end
end
