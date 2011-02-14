Shake
=====

Simple command runner.

Shake intends to replicate Thor/Rake's basic functionality in one very small package.

Why you ask? Usually because Rake doesn`t support arguments, and Thor can be too huge for your purposes.

    # Shakefile
    # Place this file in your project somewhere
    class Shake
      task(:start) {
        puts "Starting '#{params.join(' ')}'..."
      }

      task.description = "Starts something"

      task(:stop) {
        puts "Stopping..."
      }

      task.description = "Stops it"
    end

In your shell:

    $ shake start server
    Starting 'server'...

    $ shake stop
    Stopping...

    $ shake help
    Commands:
      start       Starts something
      stop        Stops it
      help        Shows a list of commands

Usage
=====

### Using Shakefiles

Using the command `shake` will load your project's `Shakefile`.

    # ~/project/Shakefile
    class Shake
      task(:deploy) do
        puts "Deploying..."
        system "ssh admin@server.com git pull && thin restart"
      end
    end

And in your shell:

    $ cd ~/project
    $ shake deploy
    Deploying...

### Common commands

Get the parameters with `params` (an array). Verify parameters with `wrong_usage`.

    Shake.task(:init) do
      wrong_usage  if params.empty?
      system "wget #{params.first}"
    end

    $ shake init
    Invalid usage.
    See `shake help` for more information.

Use `err` to print something to STDERR. Use `pass` to halt execution.

    Shake.task(:delete) do
      unless File.exists?(params.first)
        err 'You can't delete something that doesn't exist!'
        pass
      end

      FileUtils.rm_rf params.first
    end

You may also pass parameters to `pass` to have it printed out before halting.

    pass 'The target already exists.'  if File.exists?(target)

### Default tasks

Use `default` to specify a default task. (The default task is usually `help`)

    class Shake
      task(:test) do
        Dir['test/**/*_test.rb'].each { |f| load f }
      end

      default :test
    end

    # Typing `shake` will be the same as `shake test`

### Invalid commands

Use `invalid` to define what happens when

    class Shake
      invalid {
        err "Invalid command. What's wrong with you?"
      }
    end

In your shell:

    $ shake foobar
    Invalid command. What's wrong with you?

### Defining helpers

Tasks are executed in the class's context, so just define your helpers like so:

    module Helpers
      def say_status(what, str)
        puts "%15s %s" % [ what, str ]
      end
    end

    class Shake
      extend Helpers
    end

Then use them in your tasks.

    class Shake
      task(:info) do
        say_status :info, "It's a fine day"
      end
    end

### Manual invocation

You can use shake in your projects without using the `shake` command. (recommended!)

    require 'shake'

    # If you want to load your own project file (optional)
    file = Shake.find_in_project('Projectfile') and load file

    # Now define some tasks, and then:
    Shake.run!

### Subclassing Shake

You may subclass shake for your own project.

By default, it will not have any of the default tasks (that is, `shake help`, and
the "invalid command" message). Use `include Defaults` if you want this behavior.

    require 'shake'

    class CLI < Shake
      include Defaults  # optional, see above

      task(:flip) do
        what = rand < 0.5 ? "heads" : "tails"
        puts "The coin says #{what}"
      end
    end

    CLI.run!

### Defining tasks

    # In your Shakefile or something
    class Shake
      task(:reset) do
        # ...
      end

      task.description = "Resets passwords."
    end

Alternatively:

    class Shake
      task(:reset) do
        # ...
      end

      task(:reset).description = "Resets passwords."
    end

