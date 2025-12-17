# frozen_string_literal: true

class Content < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :title, :body, presence: true
  validates :title, uniqueness: { case_sensitive: false, scope: :user_id, message: 'already exists for this user' }
end
