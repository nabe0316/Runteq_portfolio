FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end

FactoryBot.define do
  factory :message do
    title { "ありがとう" }
    content { "いつもありがとうございます。" }
    association :user
  end
end
