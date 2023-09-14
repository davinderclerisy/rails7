class UsersController < ApplicationController 
    
    # GET /profile/me
    def me 
        render_response(@current_user.as_json())
    end 
    
end