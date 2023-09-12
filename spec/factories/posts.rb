FactoryBot.define do
  factory :post do
    sequence(:id) { |n| n }
    title { 'This is a title' }
    body { 'This is a post' }

    # Define a transient attribute to accept a user object or user ID
    transient do
      user_association { nil }
    end

    # Use the user association provided or create a new user if not provided
    user do
      if user_association
        user_association
      else
        FactoryBot.create(:user) rescue nil
      end
    end
  end
end
