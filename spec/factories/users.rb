FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test10example.com'}
    password { 'password' }
  end
end
