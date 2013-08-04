require "test_helper"

class TranscriptionsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @transcription = FactoryGirl.create(:transcription)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transcriptions)
  end

  test "should export as txt" do
    get :export, format: 'txt'
    assert_response :success
    assert_not_nil assigns(:transcriptions)
  end

  test "should export as transcription" do
    get :export, format: 'transcription'
    assert_response :success
    assert_not_nil assigns(:transcriptions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Transcription.count') do
      post :create, transcription:  factory_attributes_with_associations_for(:transcription)
    end

    assert_redirected_to transcription_path(assigns(:transcription))
  end

  test "should show" do
    get :show, id: @transcription
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transcription
    assert_response :success
  end

  test "should update" do
    put :update, id: @transcription, transcription: FactoryGirl.attributes_for(:transcription)
    assert_redirected_to transcription_path(assigns(:transcription))
  end

  test "should fail on bad create" do
    post :create, transcription: { non_existing: 1 }
    assert_response :success
    assert_template :new
  end

  test "should fail on bad update" do
    put :update, id: @transcription, transcription: { segment_id: nil }
    assert_response :success
    assert_template :edit
  end

  test "should destroy" do
    assert_difference('Transcription.count', -1) do
      delete :destroy, id: @transcription
    end

    assert_redirected_to transcriptions_path
  end
end
