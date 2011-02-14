Shake
=====

Simple command runner.

    # Shakefile
    # Place this file in your project somewhere
    Shake.task(:start) {
        puts "Starting '#{params.join(' ')}'..."
    }

    Shake.task.description = "Starts something"

    Shake.task(:stop) {
        puts "Stopping..."
    }

    Shake.task.description = "Stops it"


    # In your shell:
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
    Shake.task(:deploy) do
      puts "Deploying..."
      system "ssh admin@server.com git pull && thin restart"
    end

    $ cd ~/project
    $ shake deploy
    Deploying...

### Manual invocation

You can use shake in your projects without using the `shake` command. (recommended)

    require 'shake'

    # If you want to load your own project file (optional)
    file = Shake.find_in_project('Projectfile') and load file

    # Now define some tasks, and then:
    Shake.run!

### Subclassing Shake

    require 'shake'

    class CLI < Shake
      include Defaults

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

