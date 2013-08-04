# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transcription do
    user_id 1
    segment_id 1
    html_body "<span>hello this is a test</span>"
    text_body "hello this is a test"
  end
end
