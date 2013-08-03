require "test_helper"

class ReviewedTranscriptionsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @reviewed_transcription = FactoryGirl.create(:reviewed_transcription)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:reviewed_transcriptions)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('ReviewedTranscription.count') do
      post :create, reviewed_transcription:  factory_attributes_with_associations_for(:reviewed_transcription)
    end

    assert_redirected_to reviewed_transcription_path(assigns(:reviewed_transcription))
  end
  
  def test_create_failed
    assert_difference('ReviewedTranscription.count',0) do
      post :create, reviewed_transcription:  factory_attributes_with_associations_for(:reviewed_transcription).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @reviewed_transcription
    assert_response :success
  end

  def test_edit
    get :edit, id: @reviewed_transcription
    assert_response :success
  end

  def test_update
    put :update, id: @reviewed_transcription, reviewed_transcription: FactoryGirl.attributes_for(:reviewed_transcription)
    assert_redirected_to reviewed_transcription_path(assigns(:reviewed_transcription))
  end
  
   def test_update_failed
    put :update, id: @reviewed_transcription, reviewed_transcription: FactoryGirl.attributes_for(:reviewed_transcription).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('ReviewedTranscription.count', -1) do
      delete :destroy, id: @reviewed_transcription
    end

    assert_redirected_to reviewed_transcriptions_path
  end
end
