Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/explorer'
  mount Rswag::Api::Engine => '/explorer'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: proc { |env| [200, {}, [ActionController::Base.new.render_to_string(template: 'index')]] }
  
  # /api/v1
  scope :api do
    scope :v1 do

      # Authentication
      scope :auth do
        post 'register', to: 'authentication#register'
        post 'login', to: 'authentication#login'
        get 'confirm-account', to: 'authentication#confirm_account'
      end

      # Profile
      scope :profile do
        get 'me', to: 'users#me'
      end

      # Posts
      scope :posts do
        post 'create', to: 'posts#create'
        get 'all', to: 'posts#index'
        patch 'update/:id', to: 'posts#update', id: /\d+/
        delete 'delete/:id', to: 'posts#destroy', id: /\d+/
        get 'show/:id', to: 'posts#show', id: /\d+/
      end
     
    end
  end

  # route fallback
  match '*path', to: proc { |env| [
    404, 
    { 'Content-Type' => 'application/json' }, 
    [{ error: :invalid_url }.to_json]
    ] 
  }, via: :all, fallback: true

end
