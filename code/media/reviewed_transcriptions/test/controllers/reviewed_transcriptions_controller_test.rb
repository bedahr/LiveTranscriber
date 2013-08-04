require "test_helper"

class ReviewedTranscriptionsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @reviewed_transcription = FactoryGirl.create(:reviewed_transcription)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviewed_transcriptions)
  end

end
