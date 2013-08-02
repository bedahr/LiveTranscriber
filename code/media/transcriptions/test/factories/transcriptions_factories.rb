# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transcription do
    user_id 1
    segment_id 1
    html_body "MyText"
    text_body "MyText"
  end
end
