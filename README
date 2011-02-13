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
