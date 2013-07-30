require "test_helper"

class LanguagesControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @language = FactoryGirl.create(:language)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:languages)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Language.count') do
      post :create, language:  factory_attributes_with_associations_for(:language)
    end

    assert_redirected_to language_path(assigns(:language))
  end
  
  def test_create_failed
    assert_difference('Language.count',0) do
      post :create, language:  factory_attributes_with_associations_for(:language).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @language
    assert_response :success
  end

  def test_edit
    get :edit, id: @language
    assert_response :success
  end

  def test_update
    put :update, id: @language, language: FactoryGirl.attributes_for(:language)
    assert_redirected_to language_path(assigns(:language))
  end
  
   def test_update_failed
    put :update, id: @language, language: FactoryGirl.attributes_for(:language).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('Language.count', -1) do
      delete :destroy, id: @language
    end

    assert_redirected_to languages_path
  end
end
