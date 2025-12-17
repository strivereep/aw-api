require 'swagger_helper'

RSpec.describe 'auth', type: :request do
  let(:Authorization) { nil }

  path '/api/v1/auth/signin' do
    post('signin auth') do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :auth, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: %w[email password]
      }


      let(:email) { 'test@email.com' }
      let(:password) { 'password' }
      let(:auth) { { email: email, password: password } }

      before { create(:user, email: email, password: password) }

      response(200, 'successful') do
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
          expect(response).to have_http_status(:ok)
          response_body = JSON.parse(response.body)
          expect(response_body['data']['attributes']['token']).to be_present
        end
      end
    end
  end
end
