# Stacks on Deck ![Version](https://img.shields.io/gem/v/stacksondeck.svg?style=flat-square)

Stupid simple Chef-Rundeck integration.


## Usage

    $ sod help
    Commands:
      sod art             # View the application art
      sod help [COMMAND]  # Describe available commands or one specific command
      sod server          # Start application web server
      sod version         # Echo the application version

You're most likely inteterested in `server`:

    $ sod help server
    Usage:
      sod server

    Options:
      -b, [--bind=BIND]                # Set Sinatra interface
                                       # Default: 0.0.0.0
      -p, [--port=N]                   # Set Sinatra port
                                       # Default: 4567
      -e, [--environment=ENVIRONMENT]  # Set Sinatra environment
                                       # Default: development
      -c, [--config=CONFIG]            # Location of Chef configuration
                                       # Default: /etc/chef/knife.rb
      -d, [--database=DATABASE]        # Location of state database
                                       # Default: /etc/sod.db
      -u, [--username=USERNAME]        # Username value for Rundeck node
                                       # Default: ${job.username}
      -r, [--refresh=N]                # Refresh interval in seconds
                                       # Default: 900
      -l, [--log=LOG]                  # Log to file instead of STDOUT
      -v, [--debug], [--no-debug]      # Enable DEBUG-level logging
      -z, [--trace], [--no-trace]      # Enable TRACE-level logging

    Start application web server