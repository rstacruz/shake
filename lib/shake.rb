require 'ostruct'

class Shake
  VERSION = "0.0.1"

  Abort = Class.new(StandardError)

  class << self
    attr_reader :params
    attr_reader :command

    # By the way: every task gets evaluated in the context of the class.
    # Just make more static methods (`def self.monkey`) if you need them
    # in your tasks.
    #
    # This also means that all the methods here are available for use
    # in your tasks.

    # Returns a list of tasks.
    # It gives out a hash with symbols as keys, and openstructs as values.
    def tasks
      @tasks ||= Hash.new
    end

    # Sets or retrieves a task.
    # If no arguments are given, it returns the last task defined.
    #
    # Examples:
    #
    #     task(:start) { ... }
    #     task(:start, description: 'Starts it') { ... }
    #     task(:start)
    #     task.description = "Starts it"
    #
    def task(what=nil, options={}, &blk)
      return @last  if what.nil?

      key = what.downcase.to_sym
      @last = tasks[key] = new_task(options, &blk)  if block_given?
      tasks[key]
    end

    # Sets or retrieves the default task.
    #
    # Examples:
    #
    #     default :default_task
    #     default { ... }
    #
    def default(what=nil, &blk)
      @default = what || blk || @default
    end

    # Sets or retrieves the 'invalid command' task.
    # See `default` for examples.
    def invalid(what=nil, &blk)
      @invalid = what || blk || @invalid
    end

    # Invokes a task with the given arguments.
    # You may even nest multiple task invocations.
    #
    # Examples:
    #
    #    invoke(:start)
    #    invoke(:start, 'nginx', 'memcache')
    #
    def invoke(what, *args)
      old, @params = @params, args
      return  if what.nil?

      begin
        return instance_eval(&what)  if what.is_a?(Proc)

        task = task(what)  or return nil
        instance_eval &task.proc
        true
      rescue Abort
        true
      ensure
        @params = old
      end
    end

    # Stops the execution of a task.
    def pass(msg=nil)
      err msg  unless msg.nil?
      raise Abort
    end

    # Halts a task because of wrong usage.
    #
    # Example:
    #
    #   wrong_usage  if params.any?
    #
    def wrong_usage
      invoke(invalid) and pass
    end

    # Runs with the given arguments and dispatches the appropriate task.
    # Use `run!` if you want to go with command line arguments.
    #
    # Example:
    #
    #     # This is equivalent to `invoke(:start, 'nginx')`
    #     run 'start', 'nginx'
    #
    def run(*argv)
      return invoke(default)  if argv.empty?

      @command = argv.shift
      invoke(@command, *argv) or invoke(invalid, *argv)
    end

    def run!
      run *ARGV
    end

    def executable
      File.basename($0)
    end

    def err(str="")
      $stderr.write "#{str}\n"
    end

    # Traverse back it's parents and find the file called `file`.
    def find_in_project(file)
      dir = Dir.pwd
      while true
        path = File.join(dir, file)
        return path  if File.exists?(path)

        parent = File.expand_path(File.join(dir, '..'))
        return nil  if parent == dir

        dir = parent
      end
    end

  protected
    def new_task(options={}, &blk)
      t = OpenStruct.new(options)
      t.proc = blk
      t
    end
  end

  # This is a list of default commands.
  # The class Shake itself uses this, but if you subclass it,
  # you will have to do `include Defaults` yourself.
  module Defaults
    def self.included(to)
      to.default :help

      to.task(:help) {
        err "Usage: #{executable} <command>"
        err
        err "Commands:"
        tasks.each { |name, task| err "  %-20s %s" % [ name, task.description ] }
      }

      to.task(:help).description = "Shows a list of commands"

      to.invalid {
        if task(command)
          err "Invalid usage."
          err "See `#{executable} help` for more info."
        else
          err "Unknown command: #{command}"
          err "See `#{executable} help` for a list of commands."
        end
      }
    end
  end

  include Defaults
end

