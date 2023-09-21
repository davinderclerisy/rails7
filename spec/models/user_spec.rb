require 'swagger_helper'

RSpec.describe User, type: :model do
    it "is not valid without a title" do
        user = User.new
        expect(user).to_not be_valid
    end

    it "is valid with valid attributes" do
        user = User.new(email: "johndoe@example.com", user_name: "johndoe", password: 'password123')
        expect(user).to be_valid
    end

    it "is not valid with an invalid 'password' value" do
        user = User.new(email: "johndoe@example.com", user_name: "johndoe", password: '12345')
        expect(user).to_not be_valid
    end
end