require "test_helper"

class WordTest < ActiveSupport::TestCase
  test "whether word is tag" do
    assert FactoryGirl.create(:tag_word).tag?
  end

  test "should strip sphinx number" do
    assert_equal "or", FactoryGirl.create(:sphinx_word).to_s
  end
end
