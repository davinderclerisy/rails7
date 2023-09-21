require 'swagger_helper'

RSpec.describe JwtToken, type: :module do
    describe '.jwt_encode' do
      it 'encodes a payload into a JWT token' do
        payload = { user_id: 1 }
        token = JwtToken.jwt_encode(payload)
        
        expect(token).to be_a(String)
      end
      
      it 'includes an expiration time in the token' do
        payload = { user_id: 1 }
        token = JwtToken.jwt_encode(payload)
        decoded = JwtToken.jwt_decode(token)
        
        expect(decoded[:exp]).to be_a(Numeric)
      end
    end
  
    describe '.jwt_decode' do
      it 'decodes a JWT token into a hash' do
        payload = { user_id: 1 }
        token = JwtToken.jwt_encode(payload)
        decoded = JwtToken.jwt_decode(token)
        
        expect(decoded).to be_a(HashWithIndifferentAccess)
        expect(decoded[:user_id]).to eq(1)
      end
    end
  end