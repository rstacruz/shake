require File.expand_path('../../test_helper', __FILE__)

class HelpTest < Test::Unit::TestCase
  class Bake < ::Shake
    include Shake::Defaults

    task :build do
      wrong_usage
      puts "work!"
    end

    task.usage = "build SOMETHING"
    task.description = "Builds."

    task :destroy do
      wrong_usage
      puts "die!"
    end
  end

  test 'help' do
    Bake.run 'help'
    assert cout == ""
    assert cerr.include? "build SOMETHING"
    assert cerr.include? "Builds."
    assert cerr.include? "destroy"
  end

  test 'wrong_usage' do
    Bake.run 'build'

    assert ! cout.include?("work!")
    assert cerr.include?("Invalid usage")
    assert cerr.include?("shake build SOMETHING")
  end

  test 'wrong_usage 2' do
    Bake.run 'destroy'

    assert ! cout.include?("die!")
    assert cerr.include?("Invalid usage")
    assert ! cerr.include?("shake destroy")
  end
end
