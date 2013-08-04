require 'rbconfig'
require 'rake/testtask'
require 'rails/test_unit/sub_test_task'

namespace :test do

  Rails::TestTask.new(single: "test:prepare")

  Rails::TestTask.new(models: "test:prepare") do |t|
    t.pattern = 'code/**/test/models/**/*_test.rb'
  end

  Rails::TestTask.new(helpers: "test:prepare") do |t|
    t.pattern = 'code/**/test/helpers/**/*_test.rb'
  end

  Rails::TestTask.new(units: "test:prepare") do |t|
    t.pattern = 'code/**/test/{models,helpers,unit}/**/*_test.rb'
  end

  Rails::TestTask.new(controllers: "test:prepare") do |t|
    t.pattern = 'code/**/test/controllers/**/*_test.rb'
  end

  Rails::TestTask.new(mailers: "test:prepare") do |t|
    t.pattern = 'code/**/test/mailers/**/*_test.rb'
  end

  Rails::TestTask.new(functionals: "test:prepare") do |t|
    t.pattern = 'code/**/test/{controllers,mailers,functional}/**/*_test.rb'
  end

  Rails::TestTask.new(integration: "test:prepare") do |t|
    t.pattern = 'code/**/test/integration/**/*_test.rb'
  end

  task :run => ['test:units', 'test:functionals', 'test:integration']

end

task default: :test

desc 'Runs test:units, test:functionals, test:integration together'
task :test do
  info = Rails::TestTask.test_info Rake.application.top_level_tasks
  if info.files.any?
    Rails::TestTask.new('test:single') { |t|
      t.test_files = info.files
    }
    ENV['TESTOPTS'] ||= info.opts
    Rake.application.top_level_tasks.replace info.tasks

    Rake::Task['test:single'].invoke
  else
    Rake::Task[ENV['TEST'] ? 'test:single' : 'test:run'].invoke
  end
end
