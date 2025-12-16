# frozen_string_literal: true

class ContentSerializer
  include JSONAPI::Serializer

  attributes :title, :body
  attribute :createdAt do |object|
    object.created_at
  end

  attribute :updatedAt do |object|
    object.updated_at
  end
end
