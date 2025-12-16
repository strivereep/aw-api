# frozen_string_literal: true

# Minimal custom application policy
# For production, we can use Pundit
# https://github.com/varvet/pundit
class ApplicationPolicy

  def initialize(user, record)
    @user = user
    @record = record
  end

  def permitted?
    false
  end

  private

  attr_reader :user, :record

  def same_user_record?
    user.id == record.user_id
  end
end
