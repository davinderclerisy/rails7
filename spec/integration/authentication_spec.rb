require 'swagger_helper'


describe 'Authentication API' do
  
  after(:all) do
    User.destroy_all
  end

  path '/auth/register' do
    post 'Register user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :user_params, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          user_name: { type: :string },
          email: { type: :string },
          password: { type: :string }
        },
        required: ['name', 'user_name', 'email', 'password']
      }

      response '200', 'OK' do
        schema type: :object,
          properties: {
            data: {
              type: "object",
              properties: {
                id: { type: :integer },
                name: { type: "string" }, 
                user_name: { type: "string" }, 
                email: { type: "string" }, 
                created_at: { type: "string", format: "date-time" }, 
                updated_at: { type: "string", format: "date-time" }
              }
            },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:user_params) { { name: 'John Doe', user_name: 'johndoetest', email: 'testuser@example.com', password: 'password123' } }

        run_test!
      end

      response '422', 'Unprocessable Entity' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:user_params) { { name: 'Invalid User', user_name: 'invalid', email: 'invalid@example.com', password: '' } }

        run_test!
      end
    end
  end

  path '/auth/login' do
    post 'Login user' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'

      parameter name: :login_params, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response '200', 'Success' do
        schema type: :object,
               properties: {
                data: {
                  type: "object",
                  properties: {
                    user: {
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        name: { type: :string },
                        user_name: { type: :string },
                        email: { type: :string },
                        created_at: { type: :string, format: :date_time },
                        updated_at: { type: :string, format: :date_time }
                      },
                      required: ['name', 'user_name', 'email']
                    },
                    token: { type: :string },
                    exp: { type: :string, format: :date_time }
                  },
                },
                message: { type: "string" }
              },
              required: ['data', 'message']

        let(:login_params) { { email: 'user@example.com', password: 'password123' } }
        let(:valid_user) { { name: 'John Doe', user_name: 'johndoe', email: 'user@example.com', password: 'password123' } }
  
        FactoryBot.create(:user) rescue nil

        run_test!
      end

      response '401', 'Unauthorized' do 
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:login_params) { { email: 'invalid@example.com', password: 'invalidpassword' } }

        run_test!
      end
    end
  end

end