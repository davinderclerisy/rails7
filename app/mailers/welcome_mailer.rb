class WelcomeMailer < ApplicationMailer
    default from: ENV.fetch('EMAIL_FROM')

    def confirm(email_to, confirmation_token = 0)
        base_url = ENV.fetch('BASE_URL')
        @confirmation_link = base_url + "/api/v1/auth/confirm-account?token=#{confirmation_token}"
        mail(to: email_to, subject: "Welcome to #{ENV.fetch('APP_NAME') { 'Ruby on Rails' }}!")
    end
end
