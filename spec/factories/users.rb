FactoryBot.define do
    factory :user do
      sequence(:id) { |n| n }
      name { 'John Doe' }
      user_name { 'johndoe' }
      email { 'user@example.com' }
      password { 'password123' }
      token { 'dummytoken' }
      is_verified { true }
    end
end
