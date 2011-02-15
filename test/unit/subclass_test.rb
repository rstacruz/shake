require File.expand_path('../../test_helper', __FILE__)

class SubclassTest < Test::Unit::TestCase
  class Bake < ::Shake
    task :melt do
      puts "Working..."
    end

    invalid do
      err "What?"
    end
  end

  test 'subclassing' do
    Bake.run 'melt'
    assert cout == "Working...\n"
  end

  test 'nothing to do' do
    Bake.run
    assert cerr.empty?
    assert cout.empty?
  end

  test 'invalid command' do
    Bake.run 'foobar'
    assert cerr == "What?\n"
  end
end
