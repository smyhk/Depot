class ApplicationController < ActionController::Base

  include SessionCounter
  before_action :authorize
  before_action :set_i18n_locale_from_parameters

  protect_from_forgery with: :exception

  private

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: "Please log in"
      end
    end

  protected

    def set_i18n_locale_from_parameters
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

end
