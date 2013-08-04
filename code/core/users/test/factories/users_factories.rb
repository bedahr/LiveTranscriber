FactoryGirl.define do
  factory :user do
    sequence(:email)      { |seq| "user#{seq}@foo.com" }
    sequence(:name)       { |seq| "User#{seq}" }

    password              { name + "password" }
    password_confirmation { name + "password" }

    initialize_with { User.where(name: name).first || User.new(attributes) }
  end
end
