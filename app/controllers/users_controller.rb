# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    user = User.new(
      first_name: permitted_params[:firstName],
      last_name: permitted_params[:lastName],
      password: permitted_params[:password],
      email: permitted_params[:email],
      country: permitted_params[:country]
    )
    if user.save
      render json: { message: 'Successfully created!' }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def permitted_params
    params.permit(
      :firstName,
      :lastName,
      :email,
      :password,
      :country
    )
  end
end
