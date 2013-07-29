ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# All LiveTranscriber tests are under code/

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  fixtures :all

  # Add more helper methods to be used by all tests here...
end
