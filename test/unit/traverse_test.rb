require File.expand_path('../../test_helper', __FILE__)

class TraverseTest < Test::Unit::TestCase
  test 'traverse backwards' do
    shakefile %{
      Shake.task(:create) { puts 'Creating...' }
    }

    Dir.mkdir 'xxx'
    Dir.chdir 'xxx'

    shake 'create'
    assert_equal "Creating...\n", cout
  end
end
