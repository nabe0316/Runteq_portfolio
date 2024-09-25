FactoryBot.define do
  factory :user do
    name { "テストユーザー" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }

    after(:create) do |user|
      create(:tree, user: user)
    end
  end
end

FactoryBot.define do
  factory :message do
    title { "ありがとう" }
    content { "いつもありがとうございます。" }
    association :user
  end
end

FactoryBot.define do
  factory :tree do
    association :user
  end
end
