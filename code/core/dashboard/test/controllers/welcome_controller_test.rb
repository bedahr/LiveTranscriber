require "test_helper"

class WelcomeControllerTest < ActionController::TestCase

  before do
    login_as("master_test")
  end

  test "should get homepage" do
    get :index
    assert_response :success
  end

end
