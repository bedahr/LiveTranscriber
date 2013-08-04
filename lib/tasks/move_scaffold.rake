require 'fileutils'

require_relative 'lib/scaffold_mover'

# Moves a scaffold to the appropriate extension folder
# Invoke like this
# =>  rake move_scaffold[ModelName,category/folder]

task :move_scaffold, :scaffold_name, :destination do |task, args|
  scaffold_name = args[:scaffold_name] || raise("no scaffold_name defined")
  destination   = args[:destination]   || raise("no destination defined")

  ## Config
  is_module                 = scaffold_name.match(/::/)
  app_files                 = ["controllers/#{scaffold_name.tableize}_controller.rb", "models/#{scaffold_name.tableize.singularize}.rb", "views/#{scaffold_name.tableize}" ]

  app_files                << "models/#{scaffold_name.split('::').first}.rb" if is_module # If namespaced

  # factory and model test don't reflect to full name eg. not module/class_test, but class_test instead
  scaffold_name_for_test    = scaffold_name.split('::').last
  scaffold_name_for_factory = scaffold_name.sub('::','_')

  test_files                = ["controllers/#{scaffold_name.tableize}_controller_test.rb", "factories/#{scaffold_name_for_factory.tableize}_factories.rb", "models/#{scaffold_name_for_test.tableize.singularize}_test.rb" ]

  remove_dir_if_module      = scaffold_name.match(/::/)
  destination_path          = File.join(Rails.root, "code", destination)

  ## Proceed?
  puts "Moving #{scaffold_name.inspect} to #{destination.inspect}: Continue?"
  STDIN.gets

  ## Init
  FileUtils.mkdir_p( destination_path )
  FileUtils.mkdir_p( File.join(destination_path, "config") )

  ## Route handling
  original_routes_path = "config/routes.rb"
  original_route       = File.read("config/routes.rb")

  if original_route.match(/(.+:#{scaffold_name.tableize}.*)/)

    File.open(original_routes_path, "w") do |f|
      f.puts $~.pre_match.split("\n").reject { |w| w.blank? }
      f.puts $~.post_match.split("\n").reject { |w| w.blank? }
    end

    File.open( File.join(destination_path, "config/routes.rb"), "a" ) do |f|
      # Ensure newline is there
      f.puts
      f.puts $1.split("\n").reject(&:blank?)
    end

    STDERR.puts "Moved Route!"

  else
    STDERR.puts "No matching route found:"
    STDERR.puts "==== #{original_routes_path}"
    STDERR.puts original_route
    STDERR.puts "/========"
  end

  #FileUtils.touch( File.join(destination_path, "config/init.rb") )

  ScaffoldMover.move_files(app_files, destination_path,  source_prefix: "app",  destination_suffix: "",     remove_dir: remove_dir_if_module)
  ScaffoldMover.move_files(test_files, destination_path, source_prefix: "test", destination_suffix: "test", remove_dir: remove_dir_if_module)

end
