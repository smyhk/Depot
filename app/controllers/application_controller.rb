class ApplicationController < ActionController::Base

  include SessionCounter
  before_action :authorize

  protect_from_forgery with: :exception

  private

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end

end
