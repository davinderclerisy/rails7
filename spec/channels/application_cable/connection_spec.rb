require 'swagger_helper'

RSpec.describe ApplicationCable::Connection, type: :channel do
    # You can write your test cases for the Connection class here.
    # For example, you might want to test specific methods or behavior.
  
    it 'inherits from ActionCable::Connection::Base' do
      expect(ApplicationCable::Connection.superclass).to eq(ActionCable::Connection::Base)
    end
  
end