#= Tests
#
# To run tests:
#   rake test:run

require 'factory_girl'

FactoryGirl.definition_file_paths = Dir.glob("code/*/*/test/factories")
FactoryGirl.find_definitions

ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'

require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

module AuthenticatedTestHelper
  def login_as(user)
    FactoryGirl.create(:user, name: user)
    @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{user}:#{user}password")
  end
end

module FactoryGirlHelperExtension
  def factory_attributes_with_associations_for(name, extra={})
    FactoryGirl.build(name).attributes.reject { |k,v| v.nil? }.merge(extra)
  end
end


class ActiveSupport::TestCase
  include AuthenticatedTestHelper
  include FactoryGirlHelperExtension

  ActiveRecord::Migration.check_pending!

  fixtures :all

  # Add more helper methods to be used by all tests here...
end
