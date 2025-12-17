require 'swagger_helper'

RSpec.describe 'users', type: :request do
  let(:Authorization) { nil }

  path '/api/v1/users/signup' do

    post('create user') do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          firstName: { type: :string },
          lastName: { type: :string },
          password: { type: :string },
          email: { type: :string },
          country: { type: :string }
        },
        required: %w[firstName lastName password email]
      }

      let(:user) { { firstName: Faker::Name.first_name, lastName: Faker::Name.last_name, password: Faker::Internet.password, email: Faker::Internet.email, country: Faker::Address.country } }

      response(201, 'successful') do
        schema(
          type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string, format: :integer },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    token: { type: :string },
                    name: { type: :string },
                    email: { type: :string },
                    country: { type: :string },
                    createdAt: { type: :string, format: :datetime },
                    updatedAt: { type: :string, format: :datetime }
                  },
                  required: %w[token name email country createdAt updatedAt]
                }
              },
              required: %w[id type attributes]
            }
          },
          required: %w[data]
        )

        run_test! do |response|
          expect(response).to have_http_status(:created)
          expect(User.count).not_to be_zero
        end
      end
    end
  end
end
