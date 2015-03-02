# Stacks on Deck ![Version](https://img.shields.io/gem/v/stacksondeck.svg?style=flat-square)

Stupid simple Chef-Rundeck integration.

Stacks on Deck (SOD) serves up a single endpoint, which may be used as URL
Resource Model Source in Rundeck. In the background, SOD searches for nodes on a
Chef server using the provided knife credentials (`--config`); results are cached
for a configurable amount of time (`--refresh`). SOD is [crash-only software](https://www.usenix.org/legacy/events/hotos03/tech/full_papers/candea/candea.pdf);
application state is backed up to disk (`--database`). You may also wish to
override the Rundeck user name to suit your environment (`--username`).


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
                                       # Default: 60
      -l, [--log=LOG]                  # Log to file instead of STDOUT
      -v, [--debug], [--no-debug]      # Enable DEBUG-level logging
      -z, [--trace], [--no-trace]      # Enable TRACE-level logging

    Start application web server

## API

### Node Resources `GET /`

Renders Chef nodes as a Rundeck Resource Model in YAML format.


## Changelog

#### v1.0.0

- Stupid simple Chef-Rundeck integration