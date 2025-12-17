# frozen_string_literal: true

class HealthController < ApplicationController
  skip_before_action :authenticate_user, only: [:up]

  def up
    render json: { message: 'ok' }, status: :ok
  end
end
