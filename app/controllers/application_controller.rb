class ApplicationController < ActionController::API
    include JwtToken

    # Action Controller Callback
    around_action :with_locale
    before_action :authenticate_user

    def with_locale
        begin
            # It takes only the locale ("language") part, like :en, :pl, not the region part, like :"en-US" or :"en-GB"
            accept_lang = request.headers["Accept-Language"]&.split(',')&.first&.split('-')&.first
            locale = params[:locale] || accept_lang || I18n.default_locale
            I18n.with_locale(locale) do
                yield
            end
        rescue I18n::InvalidLocale
            render_response({}, :bad_request, I18n.t('invalid_locale'))
        rescue ActiveRecord::StatementInvalid => e
            puts e.full_message
            render_response({}, :bad_request, I18n.t('response.invalid_parameters'))
        rescue => e
            puts e.full_message
            render_response({}, :internal_server_error, e.message)
        end
    end

    def render_response(data, status = :ok, message = I18n.t('response.success'))
        render json: {
          data: data,
          message: message
        }, status: status
    end

    private
    def authenticate_user
        header = request.headers["Authorization"]
        token = header&.split(" ")&.last if header
        begin
            @decoded = JwtToken.jwt_decode(token)
            ActiveRecord::Base.logger.silence do
                @current_user = User.find(@decoded[:user_id])
                if @current_user == nil
                    render_response({}, :unauthorized, I18n.t('auth.invalid_token'))
                elsif !@current_user&.is_verified
                    render_response({}, :unauthorized, I18n.t('auth.not_verified'))
                end
            end
        rescue => e
            render_response({}, :unauthorized, I18n.t('auth.invalid_token'))
        end
    end
end
