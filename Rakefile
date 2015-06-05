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

namespace :admin do
  task :create do
    Dir.chdir "./test/dummy"
    exec "./bin/rake admin:create"
  end
end

task :server do
  Dir.chdir "./test/dummy"
  system "./bin/rake db:migrate"
  exec "./bin/rails server --port 8080"
end

task :console do
  Dir.chdir "./test/dummy"
  system "./bin/rake db:migrate"
  exec "./bin/rails console"
end
