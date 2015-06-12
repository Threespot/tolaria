require "bundler/setup"

TOLARIA_ROOT = File.dirname(__FILE__)

Bundler::GemHelper.install_tasks

require "rake/testtask"

Rake::TestTask.new(:test) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.pattern = "test/**/*_test.rb"
  t.verbose = false
end

task default: :test

desc "Create an admin in the demo development database"
namespace :admin do
  task :create do
    Dir.chdir "#{TOLARIA_ROOT}/test/demo"
    system "./bin/rake db:migrate"
    exec "./bin/rake admin:create"
  end
end

desc "Migrate the development database"
namespace :db do
  task :migrate do
    Dir.chdir "#{TOLARIA_ROOT}/test/demo"
    system "./bin/rake db:migrate"
  end
end

desc "Start a Rails Webrick server with Tolaria and some example models loaded"
task :server do
  port = ENV.fetch("PORT", 8080)
  binding = ENV.fetch("BIND_ON", "0.0.0.0")
  Dir.chdir "#{TOLARIA_ROOT}/test/demo"
  system "./bin/rake db:migrate"
  exec "./bin/rails server --environment development --bind #{binding} --port #{port}"
end

desc "Start a Rails console with Tolaria loaded"
task :console do
  Dir.chdir "#{TOLARIA_ROOT}/test/demo"
  system "./bin/rake db:migrate"
  exec "./bin/rails console"
end

desc "Start a Rails console with Tolaria loaded (same as `rake console`)"
task :shell => :console
