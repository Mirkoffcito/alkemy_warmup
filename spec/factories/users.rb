FactoryBot.define do
    factory :user do
      email { Faker::Internet.email }
      name { Faker::Name.name }
      uid { email }
      password { '12345678' }
      password_confirmation { password }
    end

    factory :user_without_uid do
      uid { '' }
    end

  end