$: << File.expand_path('../../lib', __FILE__)

require 'shake'
require 'contest'
require 'fileutils'

require File.expand_path('../mock', __FILE__)

class Test::Unit::TestCase
  def temp_path(*a)
    root %w(test tmp) + a
  end

  def root(*a)
    File.join File.expand_path('../../', __FILE__), *a
  end

  setup do
    $out, $err = '', ''
    FileUtils.rm_rf temp_path  if File.directory?(temp_path)
    FileUtils.mkdir_p temp_path
    Dir.chdir temp_path
  end

  teardown do
    FileUtils.rm_rf temp_path
  end

  def cout
    $out
  end

  def cerr
    $err
  end

  # Simulate bin/shake
  def shake(*args)
    ARGV.slice! 0, ARGV.length
    args.each { |a| ARGV << a }
    load File.expand_path('../../bin/shake', __FILE__)
  end

  def shakefile(str)
    File.open('Shakefile', 'w') { |f| f.write str.strip }
  end
end
