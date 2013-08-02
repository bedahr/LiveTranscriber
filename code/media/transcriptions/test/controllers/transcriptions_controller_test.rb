require "test_helper"

class TranscriptionsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @transcription = FactoryGirl.create(:transcription)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:transcriptions)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Transcription.count') do
      post :create, transcription:  factory_attributes_with_associations_for(:transcription)
    end

    assert_redirected_to transcription_path(assigns(:transcription))
  end
  
  def test_create_failed
    assert_difference('Transcription.count',0) do
      post :create, transcription:  factory_attributes_with_associations_for(:transcription).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @transcription
    assert_response :success
  end

  def test_edit
    get :edit, id: @transcription
    assert_response :success
  end

  def test_update
    put :update, id: @transcription, transcription: FactoryGirl.attributes_for(:transcription)
    assert_redirected_to transcription_path(assigns(:transcription))
  end
  
   def test_update_failed
    put :update, id: @transcription, transcription: FactoryGirl.attributes_for(:transcription).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('Transcription.count', -1) do
      delete :destroy, id: @transcription
    end

    assert_redirected_to transcriptions_path
  end
end
