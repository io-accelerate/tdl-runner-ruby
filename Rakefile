require 'rake/testtask'


#~~~~~~~ Test

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

#~~~~~~~~~ Play

desc 'Run the client'
task :run do
  sh "ruby -I lib lib/send_command_to_server.rb #{ENV['action']}"
end