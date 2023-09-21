require 'swagger_helper'

RSpec.describe WelcomeJob, type: :job do
    describe '#perform' do
      let(:email_to) { 'test@example.com' }
      let(:confirmation_token) { 'abc123' }
  
      it 'enqueues the job with the correct queue name' do
        expect {
          WelcomeJob.perform_later(email_to, confirmation_token)
        }.to have_enqueued_job.on_queue('mail_queue')
      end
  
      it 'calls WelcomeMailer.confirm to send a confirmation email' do
        expect(WelcomeMailer).to receive(:confirm).with(email_to, confirmation_token).and_return(double('mail', deliver: true))
  
        WelcomeJob.new.perform(email_to, confirmation_token)
      end
    end
end