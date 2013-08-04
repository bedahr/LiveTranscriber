require "test_helper"

class WordTest < ActiveSupport::TestCase
  test "whether word is tag" do
    assert FactoryGirl.create(:tag_word).tag?
  end

  test "should strip sphinx number" do
    assert_equal "or", FactoryGirl.create(:sphinx_word).to_s
  end

  test "should return suggestions" do
    word = FactoryGirl.create(:a_test_word)

    assert_equal [ "attest", "affex twins", ], word.alternatives.collect { |k| k[:word] }
    assert_equal [ "attest", "affex", ],       word.suggestions
  end

  test "should return empty suggestions" do
    assert_equal [], FactoryGirl.create(:no_alternatives_word).suggestions
  end
end
