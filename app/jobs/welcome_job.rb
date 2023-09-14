class WelcomeJob < ApplicationJob
  queue_as :mail_queue

  def perform(email_to, confirmation_token)
    WelcomeMailer.confirm(email_to, confirmation_token).deliver
  end
end
