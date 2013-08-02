require "test_helper"

class SegmentsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @segment = FactoryGirl.create(:segment)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:segments)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Segment.count') do
      post :create, segment:  factory_attributes_with_associations_for(:segment)
    end

    assert_redirected_to segment_path(assigns(:segment))
  end
  
  def test_create_failed
    assert_difference('Segment.count',0) do
      post :create, segment:  factory_attributes_with_associations_for(:segment).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @segment
    assert_response :success
  end

  def test_edit
    get :edit, id: @segment
    assert_response :success
  end

  def test_update
    put :update, id: @segment, segment: FactoryGirl.attributes_for(:segment)
    assert_redirected_to segment_path(assigns(:segment))
  end
  
   def test_update_failed
    put :update, id: @segment, segment: FactoryGirl.attributes_for(:segment).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('Segment.count', -1) do
      delete :destroy, id: @segment
    end

    assert_redirected_to segments_path
  end
end
