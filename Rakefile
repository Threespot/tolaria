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

desc "Create an admin in the dummy development database"
namespace :admin do
  task :create do
    Dir.chdir "./test/dummy"
    system "./bin/rake db:migrate"
    exec "./bin/rake admin:create"
  end
end

desc "Migrate the development database"
namespace :db do
  task :migrate do
    Dir.chdir "./test/dummy"
    system "./bin/rake db:migrate"
  end
end

desc "Start a Rails Webrick server with Tolaria and some example models loaded"
task :server do
  port = ENV.fetch("PORT", 8080)
  Dir.chdir "./test/dummy"
  system "./bin/rake db:migrate"
  exec "./bin/rails server --port #{port}"
end

desc "Start a Rails console with Tolaria loaded"
task :console do
  Dir.chdir "./test/dummy"
  system "./bin/rake db:migrate"
  exec "./bin/rails console"
end
