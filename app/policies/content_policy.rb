# frozen_string_literal: true

class ContentPolicy < ApplicationPolicy
  def update?
    same_user_record?
  end

  def destroy?
    same_user_record?
  end
end
