class HomeController < ApplicationController
  def index
  	@name = current_user.name if current_user
  end
end
