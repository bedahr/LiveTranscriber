require "test_helper"

class SpeakersControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @speaker = FactoryGirl.create(:speaker)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:speakers)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Speaker.count') do
      post :create, speaker:  factory_attributes_with_associations_for(:speaker)
    end

    assert_redirected_to speaker_path(assigns(:speaker))
  end
  
  def test_create_failed
    assert_difference('Speaker.count',0) do
      post :create, speaker:  factory_attributes_with_associations_for(:speaker).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @speaker
    assert_response :success
  end

  def test_edit
    get :edit, id: @speaker
    assert_response :success
  end

  def test_update
    put :update, id: @speaker, speaker: FactoryGirl.attributes_for(:speaker)
    assert_redirected_to speaker_path(assigns(:speaker))
  end
  
   def test_update_failed
    put :update, id: @speaker, speaker: FactoryGirl.attributes_for(:speaker).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('Speaker.count', -1) do
      delete :destroy, id: @speaker
    end

    assert_redirected_to speakers_path
  end
end
