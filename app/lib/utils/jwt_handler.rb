# frozen_string_literal: true

module Utils
  module JwtHandler
    module_function

    SECRET_KEY = Rails.application.credentials.secret_key_base

    def encode(payload, exp = 6.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      JWT.decode(token, SECRET_KEY)[0]
    rescue JWT::ExpiredSignature => e
      Rails.logger.error("JWT Expired Signature: #{e.message}")
      nil
    rescue JWT::VerificationError => e
      Rails.logger.error("JWT Verification Error: #{e.message}")
      nil
    rescue JWT::DecodeError => e
      Rails.logger.error("JWT Decode Error: #{e.message}")
      nil
    end
  end
end
