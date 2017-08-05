class ApplicationController < ActionController::Base

  include SessionCounter

  protect_from_forgery with: :exception

end
