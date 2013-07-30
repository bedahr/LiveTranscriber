# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(:name => "Simon", :password => "livetranscriber", :email => "simon@livetranscriber.org")

# Selecting languages with flags
common_languages = LanguageList::COMMON_LANGUAGES.select do |language|
  File.exists?(File.join("vendor/assets/images/flags", "#{language.iso_639_1}.png"))
end

# Creating Languages
common_languages.each do |language|
  k   = Language.where(:long_code => language.iso_639_3).first
  k ||= Language.create(:name => language.name, :short_code => language.iso_639_1, :long_code => language.iso_639_3)
end

# Fixing Greek Name
Language.find_by_long_code('ell').update_attribute(:name, "Greek")
