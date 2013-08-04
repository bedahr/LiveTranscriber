# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :word do
    recording_id 1
    body "MyString"
    start_time 1.5
    end_time 1.5
    confidence 1.5
  end

  factory :tag_word, class: Word do
    recording_id 1
    body "<sil>"
  end

  factory :sphinx_word, class: Word do
    recording_id 1
    body "or(2)"
  end

  factory :a_test_word, class: Word do
    recording_id 1
    body "a test"
    alternatives { [ { word: "attest" }, { word: "affex twins" } ] }
  end

  factory :no_alternatives_word, class: Word do
    recording_id 1
    body "ugamagoma"
    alternatives nil
  end


end
