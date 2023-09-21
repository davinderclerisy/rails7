require 'swagger_helper'

RSpec.describe WelcomeMailer, type: :mailer do
  describe '#confirm' do
    let(:email_to) { 'test@example.com' }
    let(:confirmation_token) { 'abc123' }

    it 'sends a confirmation email with the correct content' do
      mail = WelcomeMailer.confirm(email_to, confirmation_token)

      # Expectations to test the email content
      expect(mail.subject).to eq("Welcome to Ruby on Rails API!") # You can adjust this based on your ENV configuration
      expect(mail.to).to eq([email_to])
      expect(mail.body.encoded).to include("Confirm Your Account")
      expect(mail.body.encoded).to include("api/v1/auth/confirm-account?token=#{confirmation_token}")
    end

    it 'uses the correct sender email' do
      mail = WelcomeMailer.confirm(email_to, confirmation_token)

      # Expectation to test the sender email
      expect(mail.from).to eq([ENV.fetch('EMAIL_FROM')])
    end
  end
end
