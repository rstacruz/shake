require File.expand_path('../../test_helper', __FILE__)

class ParamsTest < Test::Unit::TestCase
  class Bake < ::Shake
    task :heat do
      wrong_usage  if params.size != 1
      puts "OK"
    end

    task :cool do
      quiet = params.delete('-q')
      type  = params.extract('-t') || params.extract('--type') || 'default'
      wrong_usage  unless params.empty?

      puts "Quiet #{!!quiet}, type #{type}"
    end

    invalid do
      err "What?"
    end
  end

  test 'wrong usage' do
    Bake.run *%w{heat}
    assert cerr == "What?\n"
  end

  test 'wrong usage 2' do
    Bake.run *%w{heat x y}
    assert cerr == "What?\n"
  end

  test 'proper usage' do
    Bake.run *%w{heat x}
    assert cout == "OK\n"
  end

  test 'cool' do
    Bake.run 'cool'
    assert cout == "Quiet false, type default\n"
  end

  test 'wrong usage' do
    Bake.run *%w{cool down}
    assert cerr == "What?\n"
  end

  test 'cool 2' do
    Bake.run *%w{cool -q}
    assert cout == "Quiet true, type default\n"
  end

  test 'cool 3' do
    Bake.run *%w{cool -t special}
    assert cout == "Quiet false, type special\n"
  end

  test 'cool 4' do
    Bake.run *%w{cool -t special -q}
    assert cout == "Quiet true, type special\n"
  end

  test 'cool 5' do
    Bake.run *%w{cool -q -t}
    assert cout == "Quiet true, type default\n"
  end

  test 'wrong usage again' do
    Bake.run *%w{cool -q xyz}
    assert cerr == "What?\n"
  end
end
