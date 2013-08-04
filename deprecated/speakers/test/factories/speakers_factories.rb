# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :speaker do
    association :language

    name "MyString"
    hidden_markov_model "MyString"
    language_model "MyString"
    dictionary "MyString"
  end
end
