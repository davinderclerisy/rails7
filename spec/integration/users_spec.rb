require 'swagger_helper'

describe 'Profile API' do

  before(:all) do
    FactoryBot.create(:user) rescue nil
    # Create a user and retrieve the token before running the tests
    post "/api/v1/auth/login", params: { email: 'user@example.com', password: 'password123' }, as: :json

    @token = JSON.parse(response.body).dig('data', 'token')
  end

  after(:all) do
    User.destroy_all
  end

  path '/profile/me' do
    get 'Get the current user' do
      tags 'Profile'
      produces 'application/json'
      security [BearerAuth: {}]

      response '200', 'OK' do
        schema type: :object,
              properties: {
                data: {
                  type: "object",
                  properties: {
                    id: { type: :integer },
                    name: { type: :string },
                    user_name: { type: :string },
                    email: { type: :string },
                    created_at: { type: :string, format: :date_time },
                    updated_at: { type: :string, format: :date_time }
                  },
                },
                message: { type: "string" }
              },
              required: ['data', 'message']

        let(:Authorization) { 'Bearer ' + @token.to_s }
        
        run_test!
      end

      response '401', 'Unauthorized' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end
end