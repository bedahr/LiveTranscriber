require "test_helper"

class LanguagesControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @language = FactoryGirl.create(:language)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:languages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Language.count') do
      post :create, language:  factory_attributes_with_associations_for(:language)
    end

    assert_redirected_to language_path(assigns(:language))
  end

  test "should show" do
    get :show, id: @language
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @language
    assert_response :success
  end

  test "should update" do
    put :update, id: @language, language: FactoryGirl.attributes_for(:language)
    assert_redirected_to language_path(assigns(:language))
  end

  test "should fail on bad create" do
    post :create, language: { non_existing: 1 }
    assert_response :success
    assert_template :new
  end

  test "should fail on bad update" do
    put :update, id: @language, language: { name: nil }
    assert_response :success
    assert_template :edit
  end

  test "should destroy" do
    assert_difference('Language.count', -1) do
      delete :destroy, id: @language
    end

    assert_redirected_to languages_path
  end
end
