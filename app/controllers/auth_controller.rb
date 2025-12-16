# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate_user, only: :signin

  def signin
    user = User.find_by_email(permitted_params[:email])
    if user&.authenticate(permitted_params[:password])
      render json: UserSerializer.new(user), status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def permitted_params
    params.require(:auth).permit(:email, :password)
  end
end
