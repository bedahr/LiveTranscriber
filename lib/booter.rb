module Booter
  def say(msg)
    puts "\e[32m[*]\e[0m #{msg}" unless ENV["RAILS_ENV"].to_s == "test"
  end

  extend self
end
