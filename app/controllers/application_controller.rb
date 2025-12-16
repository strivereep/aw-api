# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate_user

  include PolicyConcern

  rescue_from NotAuthorizedError, with: :render_not_authorized

  private

  def authenticate_user
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def logged_in?
    # devise standard way of checking
    # always returns true or false
    !!current_user
  end

  def current_user
    @current_user ||= User.find_by_id(decoded_token['user_id']) if decoded_token
  end

  def decoded_token
    header = request.headers['Authorization']
    token = header ? header.split(' ').last : nil
    decoded_jwt_token = Utils::JwtHandler.decode(token)
    decoded_jwt_token
  rescue ActiveRecord::RecordNotFound
    # explicit return nil for better error handling
    # result better performance especially with error tracing tool
    # like honeybadger, sentry
    render json: { error: 'User not found' }, status: :unauthorized
    nil
  rescue JWTDecodeError => e
    render json: { error: "JWT Decode Error: #{e.message}" }
    nil
  rescue => e
    render json: { error: "Error: #{e.message}" }
    nil
  end

  def render_not_authorized
    render json: { error: 'You are not authorized to perform this action' }, status: :unauthorized
  end
end
