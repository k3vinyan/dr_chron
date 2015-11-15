class AuthController < ApplicationController
  def authenticate
    redirect_to "https://drchrono.com/o/authorize/?redirect_uri=#{ENV['REDIRECT_URI']}&response_type=code&client_id=#{ENV['CLIENT_ID']}"
  end

  def authorize
    auth_endpoint = post_token_code
    user_endpoint = get_auth_token(auth_endpoint['access_token'])

    find_or_create_user(auth_endpoint, user_endpoint)
    fail
  end

  private
    def post_token_code
      HTTParty.post('https://drchrono.com/o/token/',
        :body => {
          :code             => params[:code],
          :grant_type       => 'authorization_code',
          :redirect_uri     => ENV['REDIRECT_URI'],
          :client_id        => ENV['CLIENT_ID'],
          :client_secret    => ENV['CLIENT_SECRET']
      })
    end

    def get_auth_token access_token
      HTTParty.get('https://drchrono.com/api/users/current',
        :headers => {
          'Authorization' => "Bearer #{access_token}",
      })
    end

    def find_or_create_user auth_endpoint, user_endpoint
      @user = User.where(username: user_endpoint['username']).first

      unless @user
        @user = User.new(
          username: user_endpoint['username'],
          access_token: auth_endpoint['access_token'],
          refresh_token: auth_endpoint['refresh_token'])
        if user_endpoint['is_doctor']
          @user.doctor_id = user_endpoint['doctor']
        end
        @user.save
      end  
    end
end
