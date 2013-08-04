# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :language do
    sequence(:name)       { |seq| "English#{seq}" }
    sequence(:short_code) { |seq| "e#{seq}" }
    sequence(:long_code)  { |seq| "en#{seq}" }
  end
end
