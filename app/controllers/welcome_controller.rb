class WelcomeController < ApplicationController
  def index
    p '*' * 100
    p params
    p '*' * 100
  end
end
