class UsersController < ApplicationController 
    
    # GET /profile/me
    def me 
        render_response(@current_user.as_json(except: [:password, :password_digest]))
    end 
    
end