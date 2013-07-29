require File.expand_path('../../lib/booter', __FILE__)

Booter.say "Booting Application"

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

Booter.say "Loading Bundles"
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
