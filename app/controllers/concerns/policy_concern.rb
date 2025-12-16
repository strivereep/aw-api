# frozen_string_literal: true

module PolicyConcern
  extend ActiveSupport::Concern

  def authorize(record, action = nil)
    policy = policy_class(record).new(current_user, record)
    action ||= "#{action_name}?".to_sym

    unless policy.public_send(action)
      raise NotAuthorizedError
    end

  rescue NoMethodError
    raise NotAuthorizedError
  end

  class NotAuthorizedError < StandardError; end

  private

  def policy_class(record)
    klass = \
      case record
      when Class
        record
      else
        record.class
      end

    "#{klass}Policy".safe_constantize
  rescue NameError
    ApplicationPolicy
  end
end
