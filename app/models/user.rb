# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  # Associations
  has_many :contents

  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, :last_name, presence: true
  # simple password validation
  # for complex validation, add more regex
  # https://gist.github.com/Thecaprifire/d739a8bda9e12bfb357babad590e8052
  validates :password, presence: true, length: { minimum: 6 }, on: :create
end
