require "test_helper"

class WordsControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
    @word = FactoryGirl.create(:word)
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:words)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('Word.count') do
      post :create, word:  factory_attributes_with_associations_for(:word)
    end

    assert_redirected_to word_path(assigns(:word))
  end
  
  def test_create_failed
    assert_difference('Word.count',0) do
      post :create, word:  factory_attributes_with_associations_for(:word).merge()
    end

    assert_response :success
    assert_template :new
  end

  def test_show
    get :show, id: @word
    assert_response :success
  end

  def test_edit
    get :edit, id: @word
    assert_response :success
  end

  def test_update
    put :update, id: @word, word: FactoryGirl.attributes_for(:word)
    assert_redirected_to word_path(assigns(:word))
  end
  
   def test_update_failed
    put :update, id: @word, word: FactoryGirl.attributes_for(:word).merge() # colision
    assert_response :success
    assert_template :edit
  end

  def test_destroy
    assert_difference('Word.count', -1) do
      delete :destroy, id: @word
    end

    assert_redirected_to words_path
  end
end
