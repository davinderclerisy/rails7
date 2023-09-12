class AuthenticationController < ApplicationController
    include JwtToken
    skip_before_action :authenticate_user, only: [:login, :register] # Action Controller Callback

    # POST /auth/login
    def login
        @user = User.find_by_email(params[:email])
        if @user&.authenticate(params[:password])
            time = Time.now + ENV.fetch('JWT_EXPIRATION', 3600).to_i
            token = JwtToken.jwt_encode({ user_id: @user.id, exp: time })
 
            render_response({ 
                user: @user.as_json(except: [:password, :password_digest]), 
                token: token, 
                exp: time 
            })
        else
            render_response({}, :unauthorized, I18n.t('auth.invalid_email_or_password'))
        end
    end

    # POST /auth/register
    def register
        @user = User.new(user_params)
        if @user.save
            render_response(@user.as_json(except: [:password, :password_digest]), :ok)
        else
            render_response({}, :unprocessable_entity, @user.errors.full_messages.join(". "))
        end
    end

    private     
    
    def user_params 
        params.permit(:name, :user_name, :email, :password) 
    end 
end
