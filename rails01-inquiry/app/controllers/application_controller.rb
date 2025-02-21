class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      pw = Rails.application.credentials.basis_auth_password
      if (username == "kanri" && password == pw)
        session[:user] = username
      end
    end
  end
end
