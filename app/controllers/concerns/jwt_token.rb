require "jwt"

module JwtToken extend ActiveSupport::Concern
    SECRET_KEY = Rails.application.secret_key_base. to_s

    def self.jwt_encode(payload)
        if !payload.key?(:exp)
            payload[:exp] = 24.hours.from_now.to_i
        end
        JWT.encode(payload, SECRET_KEY)
    end
    
    def self.jwt_decode(token)
        decoded = JWT.decode(token, SECRET_KEY, true)[0]
        HashWithIndifferentAccess.new(decoded)
    end
end