require "test_helper"

class TranscriptionTest < ActiveSupport::TestCase

  test "should return raw_words" do
    assert_equal %w(hello this is a test), FactoryGirl.create(:transcription).raw_words
  end
end
