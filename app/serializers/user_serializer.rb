# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer

  attribute :token do |object|
    ::Utils::JwtHandler.encode(user_id: object.id)
  end

  attributes :email, :country
  attribute :name do |object|
    "#{object.first_name} #{object.last_name}"
  end

  attribute :createdAt do |object|
    object.created_at
  end

  attribute :updatedAt do |object|
    object.updated_at
  end
end
