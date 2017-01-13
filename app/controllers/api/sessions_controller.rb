module Api
  class SessionsController < Api::ApiController

    before_action :authenticate_user!, only: [:destroy]

    def create
      user = User.find_by(email: login_params[:email])
      if user && user.verified_password?(login_params[:password])
        @current_user = user
        render json: { user: user.attributes.except('password', 'password_confirmation'), status: 200, token: user.authentication_token },
               status: 200
      else
        render json: {message: "Error, Unauthorized", status: 401},
               status: :unauthorized
      end
    end

    def destroy
      @current_user = nil if @current_user.generate_new_authentication_token
      render json: { message: 'Session deleted and token refreshed', status: 200 }, status: 200
    end

    private
    def login_params
      params.require(:user).permit(:email, :password)
    end
  end
end
