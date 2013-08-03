# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :reviewed_transcription do
    user_id 1
    transcription_id 1
    text_body "MyText"
    html_answer "MyText"
    mine_words "MyText"
    spotted_mistakes "MyText"
    has_mines_spotted false
  end
end
