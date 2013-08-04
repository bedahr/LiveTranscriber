require 'factory_girl'

FactoryGirl.definition_file_paths = Dir.glob("code/*/*/test/factories")
FactoryGirl.find_definitions

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

# All tests are under code/

module AuthenticatedTestHelper
  def login_as(user)
    FactoryGirl.create(:user, name: user)
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user}:#{user}password")
  end
end

class ActiveSupport::TestCase
  include AuthenticatedTestHelper

  ActiveRecord::Migration.check_pending!

  fixtures :all

  # Add more helper methods to be used by all tests here...
end
