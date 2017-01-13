class Api::ApiController < ActionController::Base

  include ActionController::ImplicitRender
  respond_to :json

  protect_from_forgery with: :null_session

  before_action :destroy_session

  def authenticate_user!
    token, options = ActionController::HttpAuthentication::Token.token_and_options(request)

    email = options.blank? ? nil : options[:email]
    user = email && User.find_by(email: email)

    if user && ActiveSupport::SecurityUtils.secure_compare(user.authentication_token, token)
      @current_user = user
    else
      render json: { status: 401, message: "unauthorized" },
             status: :unauthorized
    end
  end

  private

  def destroy_session
    request.session_options[:skip] = true
  end

end
