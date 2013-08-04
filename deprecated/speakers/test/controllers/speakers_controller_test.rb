require "test_helper"

class SpeakersControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @speaker = FactoryGirl.create(:speaker)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:speakers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Speaker.count') do
      post :create, speaker:  factory_attributes_with_associations_for(:speaker)
    end

    assert_redirected_to speaker_path(assigns(:speaker))
  end

  test "should show" do
    get :show, id: @speaker
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @speaker
    assert_response :success
  end

  test "should update" do
    put :update, id: @speaker, speaker: FactoryGirl.attributes_for(:speaker)
    assert_redirected_to speaker_path(assigns(:speaker))
  end

  test "should destroy" do
    assert_difference('Speaker.count', -1) do
      delete :destroy, id: @speaker
    end

    assert_redirected_to speakers_path
  end
end
