require "test_helper"

class WordsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @word = FactoryGirl.create(:word)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create" do
    assert_difference('Word.count') do
      post :create, word:  factory_attributes_with_associations_for(:word)
    end

    assert_redirected_to word_path(assigns(:word))
  end

  test "should fail on bad create" do
    post :create, word: { non_existing: 1 }
    assert_response :success
    assert_template :new
  end

  test "should show" do
    get :show, id: @word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @word
    assert_response :success
  end

  test "should update" do
    put :update, id: @word, word: FactoryGirl.attributes_for(:word)
    assert_redirected_to word_path(assigns(:word))
  end

  test "should fail on bad update" do
    put :update, id: @word, word: { body: nil }
    assert_response :success
    assert_template :edit
  end

  test "should destroy" do
    assert_difference('Word.count', -1) do
      delete :destroy, id: @word
    end

    assert_redirected_to words_path
  end
end
