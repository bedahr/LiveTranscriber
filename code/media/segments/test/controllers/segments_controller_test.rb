require "test_helper"

class SegmentsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @segment = FactoryGirl.create(:segment)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:segments)
  end

  test "should export as txt" do
    get :export, format: 'txt'
    assert_response :success
    assert_not_nil assigns(:segments)
  end

  test "should export as transcription" do
    get :export, format: 'transcription'
    assert_response :success
    assert_not_nil assigns(:segments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Segment.count') do
      post :create, segment:  factory_attributes_with_associations_for(:segment)
    end

    assert_redirected_to segment_path(assigns(:segment))
  end

  test "should show" do
    get :show, id: @segment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @segment
    assert_response :success
  end

  test "should update" do
    put :update, id: @segment, segment: FactoryGirl.attributes_for(:segment)
    assert_redirected_to segment_path(assigns(:segment))
  end

  test "should fail on bad create" do
    post :create, segment: { non_existing: 1 }
    assert_response :success
    assert_template :new
  end

  test "should fail on bad update" do
    put :update, id: @segment, segment: { recording_id: nil }
    assert_response :success
    assert_template :edit
  end


  test "should destroy" do
    assert_difference('Segment.count', -1) do
      delete :destroy, id: @segment
    end

    assert_redirected_to segments_path
  end
end
