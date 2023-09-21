require 'swagger_helper'

RSpec.describe ApplicationController, type: :controller do
    controller do
      def index
        render_response(data: { message: 'Hello, World!' })
      end
    end
  
    describe 'before_action :authenticate_user' do
      it 'calls authenticate_user before the action' do
        expect(controller).to receive(:authenticate_user)
        get :index
      end
    end
  
    describe 'around_action :with_locale' do
      it 'calls with_locale around the action' do
        expect(controller).to receive(:with_locale)
        get :index
      end
    end
  
    describe '#with_locale' do
      it 'sets the locale based on request headers' do
        request.headers['Accept-Language'] = 'en-US,es-ES'
        get :index, params: { locale: 'fr' }
        expect(I18n.locale).to eq(:en)
      end
  
      it 'falls back to the default locale if no language is specified' do
        get :index
        expect(I18n.locale).to eq(I18n.default_locale)
      end
  
      it 'handles invalid locales gracefully' do
        request.headers['Accept-Language'] = 'invalid-locale'
        get :index
        expect(response).to have_http_status(:bad_request)
      end

      it 'handles ActiveRecord exceptions and renders an error response' do
        allow(I18n).to receive(:with_locale).and_raise(ActiveRecord::StatementInvalid.new('Test error'))
        get :index
        expect(response).to have_http_status(:bad_request)
      end

      it 'handles exceptions and renders an error response' do
        allow(I18n).to receive(:with_locale).and_raise(StandardError.new('Test error'))
        get :index
        expect(response).to have_http_status(:internal_server_error)
      end
    end
  
    describe '#authenticate_user' do
      it 'authenticates a user based on a valid token' do
        valid_token = JwtToken.jwt_encode(user_id: 1)
        request.headers['Authorization'] = "Bearer #{valid_token}"
  
        expect(User).to receive(:find).with(1).and_return(double('user', is_verified: true))
        get :index
  
        expect(response).to have_http_status(:ok)
      end
  
      it 'handles invalid tokens gracefully' do
        invalid_token = 'invalid-token'
        request.headers['Authorization'] = "Bearer #{invalid_token}"
  
        get :index
  
        expect(response).to have_http_status(:unauthorized)
      end
  
      it 'handles non-verified users gracefully' do
        valid_token = JwtToken.jwt_encode(user_id: 1)
        request.headers['Authorization'] = "Bearer #{valid_token}"
  
        expect(User).to receive(:find).with(1).and_return(double('user', is_verified: false))
        get :index
  
        expect(response).to have_http_status(:unauthorized)
      end

      it 'handles not exist users gracefully' do
        valid_token = JwtToken.jwt_encode(user_id: 1)
        request.headers['Authorization'] = "Bearer #{valid_token}"
  
        expect(User).to receive(:find).with(1).and_return(nil)
        get :index
  
        expect(response).to have_http_status(:unauthorized)
      end
  
      it 'handles exceptions and renders an error response' do
        allow(JwtToken).to receive(:jwt_decode).and_raise(StandardError.new('Test error'))
        request.headers['Authorization'] = 'Bearer valid-token'
  
        get :index
  
        expect(response).to have_http_status(:unauthorized)
      end
    end
end