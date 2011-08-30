task :test do
  Dir['test/**/*_test.rb'].each { |f| load f }
end

desc "Invokes the test suite in multiple RVM environments"
task :'test!' do
  # Override this by adding RVM_TEST_ENVS=".." in .rvmrc
  envs = ENV['RVM_TEST_ENVS'] || '1.9.2@shake,1.8.7@shake'
  puts "* Testing in the following RVM environments: #{envs.gsub(',', ', ')}"
  system "rvm #{envs} rake test"
end


task :default => :test
