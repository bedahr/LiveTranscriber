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

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create" do
  #   assert_difference('ReviewedTranscription.count') do
  #     post :create, reviewed_transcription:  factory_attributes_with_associations_for(:reviewed_transcription)
  #   end
  #
  #   assert_redirected_to reviewed_transcription_path(assigns(:reviewed_transcription))
  # end

  test "should show" do
    get :show, id: @reviewed_transcription
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @reviewed_transcription
    assert_response :success
  end

  # test "should update" do
  #   put :update, id: @reviewed_transcription, reviewed_transcription: FactoryGirl.attributes_for(:reviewed_transcription)
  #   assert_redirected_to reviewed_transcription_path(assigns(:reviewed_transcription))
  # end

  test "should destroy" do
    assert_difference('ReviewedTranscription.count', -1) do
      delete :destroy, id: @reviewed_transcription
    end

    assert_redirected_to reviewed_transcriptions_path
  end
end
