require 'swagger_helper'

describe 'Posts API' do

  before(:all) do
    @current_user = FactoryBot.create(:user, email: 'user@example.com', password: 'password123') rescue nil
    # Create a user and retrieve the token before running the tests
    post "/api/v1/auth/login", params: { email: 'user@example.com', password: 'password123' }, as: :json

    @token = JSON.parse(response.body).dig('data', 'token')
    @user_id = JSON.parse(response.body).dig('data', 'user', 'id')
  end

  after(:all) do
    User.destroy_all
  end

  path '/posts/all' do
    get 'Retrieves a list of posts' do
      tags 'Posts'
      produces 'application/json'
      security [BearerAuth: []]
      parameter name: :page, in: :query, type: :integer, description: 'Page number (default: 1)'
      parameter name: :per_page, in: :query, type: :integer, description: 'Items per page (default: 10)'

      response '200', 'Posts found' do
        schema type: :object,
          properties: {
            data: {
              type: "object",
              properties: {
                pagination: {
                  type: :object,
                  properties: {
                    page: { type: :integer },
                    per_page: { type: :integer },
                    total_pages: { type: :integer },
                    total_count: { type: :integer }
                  }
                },
                rows: {
                  type: :array,
                  items: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      title: { type: :string },
                      body: { type: :string },
                      user_id: { type: :integer },
                      is_public: { type: :boolean },
                      is_draft: { type: :boolean },
                      created_at: { type: :string },
                      updated_at: { type: :string },
                      user: {
                        type: :object,
                        properties: {
                          name: { type: :string }
                        }
                      }
                    }
                  }
                }
              }
            },
            message: { type: "string" }
          }

        let(:page) { 1 }
        let(:per_page) { 10 }
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
        let(:page) { 1 }
        let(:per_page) { 10 }
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end

  path '/posts/create' do
    post 'Creates a new post' do
      tags 'Posts'
      produces 'application/json'
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :post_body, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string },
          is_public: { type: :boolean },
          is_draft: { type: :boolean }
        },
        required: ['title', 'body']
      }

      response '200', 'Post created' do
        schema type: :object,
          properties: {
            data: {
              type: "object",
              properties: {
                id: { type: :integer },
                title: { type: :string },
                body: { type: :string },
                user_id: { type: :integer },
                is_public: { type: :boolean },
                is_draft: { type: :boolean },
                created_at: { type: :string },
                updated_at: { type: :string }
              }
            },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:Authorization) { 'Bearer ' + @token.to_s }
        let(:post_body) { { title: 'New Post', body: 'This is a new post', is_public: true, is_draft: false } }

        run_test!
      end

      response '422', 'Invalid post data' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']
          
        let(:post_body) { { title: nil, body: 'This is a new post', is_public: true, is_draft: false } }
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
        let(:post_body) { { title: 'New Post', body: 'This is a new post', is_public: true, is_draft: false } }
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end

  path '/posts/show/{id}' do
    get 'Retrieves a single post by ID' do
      tags 'Posts'
      produces 'application/json'
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, description: 'Post ID'

      response '200', 'Post found' do
        schema type: :object,
          properties: {
            data: {
              type: "object",
              properties: {
                id: { type: :integer },
                title: { type: :string },
                body: { type: :string },
                user_id: { type: :integer },
                is_public: { type: :boolean },
                is_draft: { type: :boolean },
                created_at: { type: :string },
                updated_at: { type: :string }
              }
            },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:Authorization) { 'Bearer ' + @token.to_s }
        run_test!
      end

      response '404', 'Post not found' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:id) { 999 }
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

        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end

  path '/posts/update/{id}' do
    patch 'Updates an existing post by ID' do
      tags 'Posts'
      produces 'application/json'
      consumes 'application/json'
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, description: 'Post ID'
      parameter name: :post_body, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          body: { type: :string },
          is_public: { type: :boolean },
          is_draft: { type: :boolean }
        }
      }
  
      response '200', 'Post updated' do
        schema type: :object,
          properties: {
            data: {
              type: "object",
              properties: {
                id: { type: :integer },
                title: { type: :string },
                body: { type: :string },
                user_id: { type: :integer },
                is_public: { type: :boolean },
                is_draft: { type: :boolean },
                created_at: { type: :string },
                updated_at: { type: :string }
              },
              required: ['id', 'title', 'body', 'user_id', 'is_public', 'is_draft', 'created_at', 'updated_at']
            },
            message: { type: "string" }
          },
          required: ['data', 'message']
          
        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:post_body) { { title: 'Updated Post Title' } }
        let(:Authorization) { 'Bearer ' + @token.to_s }
        run_test!
      end
  
      response '404', 'Post not found' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:id) { 999 }
        let(:post_body) { { title: 'Updated Post Title' } }
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

        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:post_body) { { title: 'Updated Post Title' } }
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end
  
  path '/posts/delete/{id}' do
    delete 'Deletes a post by ID' do
      tags 'Posts'
      produces 'application/json'
      security [BearerAuth: []]
      parameter name: :id, in: :path, type: :integer, description: 'Post ID'
  
      response '200', 'Post deleted' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:Authorization) { 'Bearer ' + @token.to_s }
        run_test!
      end
  
      response '404', 'Post not found' do
        schema type: :object,
          properties: {
            data: { type: "object" },
            message: { type: "string" }
          },
          required: ['data', 'message']

        let(:id) { 999 }
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

        let(:id) { 
          findUser = User.find_by(id: @user_id);
          post = FactoryBot.create(:post, user_association: findUser) rescue nil
          post.id
        }
        let(:Authorization) { 'Bearer invalid_token' }

        run_test!
      end
    end
  end

end