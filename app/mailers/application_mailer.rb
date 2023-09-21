class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('EMAIL_FROM')
  layout "mailer"
end
