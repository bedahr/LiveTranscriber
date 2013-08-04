require "test_helper"

class RecordingsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @recording = FactoryGirl.create(:recording)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recordings)
  end

  test "should get my recordings" do
    get :my
    assert_response :success
    assert_not_nil assigns(:recordings)
  end

  test "should show segments as vtt" do
    get :segments, format: 'vtt', id: @recording
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Recording.count') do
      post :create, recording:  factory_attributes_with_associations_for(:recording)
    end

    assert_redirected_to recording_path(assigns(:recording))
  end

  test "should show" do
    get :show, id: @recording
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recording
    assert_response :success
  end

  test "should update" do
    put :update, id: @recording, recording: FactoryGirl.attributes_for(:recording)
    assert_redirected_to recording_path(assigns(:recording))
  end

  test "should destroy" do
    assert_difference('Recording.count', -1) do
      delete :destroy, id: @recording
    end

    assert_redirected_to recordings_path
  end
end
