# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'contents', type: :request do
  let(:user) { create(:user) }
  let(:jwt_token) do
    post '/api/v1/auth/signin', params: { auth: { email: user.email, password: user.password } }
    JSON.parse(response.body)&.dig('data', 'attributes', 'token')
  end

  let(:Authorization) { jwt_token }

  before { sign_in user }

  path '/api/v1/contents' do
    get('list contents') do
      tags 'Contents'
      produces 'application/json'

      context 'when contents exist' do
        before do
          create(:content, user: user)
          create(:content, user: user)
          create(:content, user: user)
        end

        response(200, 'successful') do
          schema(
            type: :object,
            properties: {
              data: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :string, format: :integer },
                    type: { type: :string },
                    attributes: {
                      type: :object,
                      properties: {
                        title: { type: :string },
                        body: { type: :string },
                        createdAt: { type: :string, format: :datetime },
                        updatedAt: { type: :string, format: :datetime }
                      },
                      required: %w[title body createdAt updatedAt]
                    }
                  },
                  required: %w[id type attributes]
                }
              }
            },
            required: %w[data]
          )
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            response_body = JSON.parse(response.body)
            expect(response_body['data'].size).to eq(3)
          end
        end
      end

      context 'when contents do not exist' do
        response(200, 'successful') do
          schema(
            type: :object,
            properties: {
              data: {
                type: :array
              }
            },
            required: %w[data]
          )
          run_test! do |response|
            expect(response).to have_http_status(:ok)
            response_body = JSON.parse(response.body)
            expect(response_body['data'].size).to eq(0)
          end
        end
      end
    end

    post('create content') do
      tags 'Contents'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :content, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string }
        },
        required: %w[title body]
      }

      let(:content) { { title: 'Content 1', body: 'Test content 1' } }

      context 'when the request is valid' do
        response(201, 'created') do
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
                      title: { type: :string },
                      body: { type: :string },
                      createdAt: { type: :string, format: :datetime },
                      updatedAt: { type: :string, format: :datetime }
                    },
                    required: %w[title body createdAt updatedAt]
                  }
                }
              }
            }
          )

          run_test! do |response|
            expect(response).to have_http_status(:created)
            expect(Content.count).not_to be_zero
            response_body = JSON.parse(response.body)
            expect(response_body['data']['attributes']['title']).to eq(content[:title])
            expect(response_body['data']['attributes']['body']).to eq(content[:body])
          end
        end
      end

      context 'when content is invalid' do
        context 'when title or body is empty' do
          let(:content) { { title: 'Test content 1', body: '' } }

          response(422, 'unprocessable entity') do
            schema(
              type: :object,
              properties: {
                error: {
                  type: :array,
                  items: {
                    type: :string
                  }
                }
              },
              required: %w[error]
            )
            run_test! do |response|
              expect(response).to have_http_status(:unprocessable_entity)
              response_body = JSON.parse(response.body)
              expect(response_body['error']).to include('Body can\'t be blank')
            end
          end
        end

        context 'when title exists (case insentive) for the same user' do
          before do
            create(:content, user: user, title: content[:title].downcase)
          end

          response(422, 'unprocessable entity') do
            schema(
              type: :object,
              properties: {
                error: {
                  type: :array,
                  items: {
                    type: :string
                  }
                }
              },
              required: %w[error]
            )
            run_test! do |response|
              expect(response).to have_http_status(:unprocessable_entity)
              response_body = JSON.parse(response.body)
              expect(response_body['error']).to include('Title already exists for this user')
            end
          end
        end
      end
    end
  end

  path '/api/v1/contents/{id}' do
    parameter name: :id, in: :path, type: :string, required: true

    put('update content') do
      tags 'Contents'
      produces 'application/json'
      consumes 'application/json'

      parameter name: :content, in: :body, required: true, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string }
        }
      }

      let(:content) { { title: 'Content 1' } }
      let(:existing_content) { create(:content, user: user) }

      before { existing_content }

      context 'when content exists' do

        let(:id) { existing_content.id }

        context 'when user is authorized' do
          context 'when valid request' do
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
                          title: { type: :string },
                          body: { type: :string },
                          createdAt: { type: :string, format: :datetime },
                          updatedAt: { type: :string, format: :datetime }
                        },
                        required: %w[title body createdAt updatedAt]
                      }
                    }
                  }
                }
              )

              run_test! do |response|
                expect(response).to have_http_status(:ok)
                response_body = JSON.parse(response.body)
                expect(response_body['data']['attributes']['title']).to eq(content[:title])
              end
            end
          end

          context 'when invalid request' do
            let(:content) { { title: '' } }

            response(422, 'unprocessable entity') do
              schema(
                type: :object,
                properties: {
                  error: {
                    type: :array,
                    items: {
                      type: :string
                    }
                  }
                },
                required: %w[error]
              )
              run_test! do |response|
                expect(response).to have_http_status(:unprocessable_entity)
                response_body = JSON.parse(response.body)
                expect(response_body['error']).to include('Title can\'t be blank')
              end
            end
          end
        end

        context 'when user is not authorized' do
          let(:another_user) { create(:user) }
          let(:jwt_token) do
            post '/api/v1/auth/signin', params: { auth: { email: another_user.email, password: another_user.password } }
            JSON.parse(response.body)&.dig('data', 'attributes', 'token')
          end

          before do
            sign_out user
            sign_in another_user
          end

          response(401, 'unauthorized') do
            run_test! do |response|
              expect(response).to have_http_status(:unauthorized)
            end
          end
        end
      end

      context 'when content does not exist' do
        let(:id) { existing_content.id + 1 }

        response(404, 'not found') do
          run_test! do |response|
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end

    delete('delete content') do
      tags 'Contents'
      produces 'application/json'

      let(:existing_content) { create(:content, user: user) }

      before { existing_content }

      context 'when content exists' do
        let(:id) { existing_content.id }

        context 'when user is authorized' do
          context 'when valid request' do
            response(200, 'successful') do
              schema(
                type: :object,
                properties: {
                  message: { type: :string }
                },
                required: %w[message]
              )

              run_test! do |response|
                expect(response).to have_http_status(:ok)
                response_body = JSON.parse(response.body)
                expect(response_body['message']).to eq 'Deleted'
              end
            end
          end
        end

        context 'when user is not authorized' do
          let(:another_user) { create(:user) }
          let(:jwt_token) do
            post '/api/v1/auth/signin', params: { auth: { email: another_user.email, password: another_user.password } }
            JSON.parse(response.body)&.dig('data', 'attributes', 'token')
          end

          before do
            sign_out user
            sign_in another_user
          end

          response(401, 'unauthorized') do
            run_test! do |response|
              expect(response).to have_http_status(:unauthorized)
            end
          end
        end
      end

      context 'when content does not exist' do
        let(:id) { existing_content.id + 1 }

        response(404, 'not found') do
          run_test! do |response|
            expect(response).to have_http_status(:not_found)
          end
        end
      end
    end
  end
end
