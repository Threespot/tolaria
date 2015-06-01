require "bundler/setup"

APP_RAKEFILE = File.expand_path("../test/dummy/Rakefile", __FILE__)

Bundler::GemHelper.install_tasks

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

task default: :test
