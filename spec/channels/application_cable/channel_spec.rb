require 'swagger_helper'

RSpec.describe ApplicationCable::Channel, type: :channel do
    # You can write your test cases for the Channel class here.
    # For example, you might want to test specific methods or behavior.
    
    it 'inherits from ActionCable::Channel::Base' do
      expect(ApplicationCable::Channel.superclass).to eq(ActionCable::Channel::Base)
    end
    
end