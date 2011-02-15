require File.expand_path('../../test_helper', __FILE__)

class ShakefileTest < Test::Unit::TestCase
  test 'no shakefile' do
    shake
    assert cout.empty?
    assert cerr.include?('No Shakefile')
  end

  context 'basics' do
    setup do
      shakefile %{
        class Shake
          task :start do
            puts "Starting..."
            puts params.inspect  if params.any?
          end
          task.description = 'Starts the server'
        end
      }
    end

    test 'help' do
      shake 'help'
      assert cout.empty?
      assert cerr =~ /^  start *Starts the server/
    end

    test 'invalid command' do
      shake 'stop'
      assert cerr.include?('Unknown command: stop')
    end

    test 'run' do
      shake 'start'
      assert_equal "Starting...\n", cout
    end

    test 'run with args' do
      shake *%w(start x)
      assert_equal "Starting...\n[\"x\"]\n", cout
    end
  end
end
