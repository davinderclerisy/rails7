class AuthenticationController < ApplicationController
    include JwtToken
    skip_before_action :authenticate_user, only: [:login, :register, :confirm_account] # Action Controller Callback

    # POST /auth/login
    def login
        @user = User.unscoped { User.find_by_email(params[:email]) }
        if @user&.authenticate(params[:password])
            time = Time.now + ENV.fetch('JWT_TOKEN_EXPIRATION', 3600).to_i
            token = JwtToken.jwt_encode({ user_id: @user.id, exp: time.to_i })
 
            render_response({ 
                user: @user.as_json(), 
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

        # Generate a token for confirmation valid until 24 hours
        @user.token = JwtToken.jwt_encode({ user_id: @user.id, exp: 24.hours.from_now.to_i })
        
        if @user.save

            WelcomeJob.perform_later @user.email, @user.token

            render_response(@user.as_json(), :ok)
        else
            render_response({}, :unprocessable_entity, @user.errors.full_messages.join(". "))
        end
    end

    # GET /auth/confirm-account
    def confirm_account
        @user = User.find_by(token: params[:token])
        if @user
            User.where(id: @user.id).update_all(is_verified: true, token: nil)
            render_response({}, :ok, I18n.t('auth.account_confirmed'))
        else
            render_response({}, :unauthorized, I18n.t('auth.link_expired'))
        end
    end

    private     
    
    def user_params 
        params.permit(:name, :user_name, :email, :password) 
    end 
end
