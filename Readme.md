# Stacks on Deck ![Version](https://img.shields.io/gem/v/stacksondeck.svg?style=flat-square)

Stupid simple Chef-Rundeck integration.

Stacks on Deck (SOD) serves up a single endpoint, which may be used as URL
Resource Model Source in Rundeck. In the background, SOD searches for nodes on a
Chef server using the provided knife credentials (`--config`); results are cached
for a configurable amount of time (`--refresh`). You may also wish to override
the Rundeck user name to suit your environment (`--username`).

**N.B.** SOD merges a Chef node's environments, roles, and tags into Rundeck
tags. This behavior is not currently configurable.


## Usage

    $ sod help
    Commands:
      sod art             # View the application art
      sod help [COMMAND]  # Describe available commands or one specific command
      sod server          # Start application web server
      sod version         # Echo the application version

You're most likely inteterested in the `server` command:

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
      -u, [--username=USERNAME]        # Username value for Rundeck node
                                       # Default: ${job.username}
      -r, [--refresh=N]                # Refresh interval in seconds
                                       # Default: 60
      -l, [--log=LOG]                  # Log to file instead of STDOUT
      -v, [--debug], [--no-debug]      # Enable DEBUG-level logging
      -z, [--trace], [--no-trace]      # Enable TRACE-level logging

    Start application web server

**N.B.** At Blue Jeans we use the [`bjn_sod` cookbook](https://github.com/sczizzo/bjn-sod-cookbook)
to deploy Stacks on Deck.

## API

### `GET /`

Renders Chef nodes as a Rundeck Resource Model in [RESOURCE-YAML](http://rundeck.org/docs/man5/resource-yaml.html):

    ---
    example-node:
      hostname: example-node
      description: example-node.example.com
      osArch: x86_64
      osVersion: '12.04'
      osFamily: debian
      osName: ubuntu
      username: "${job.username}"
      remoteUrl: http://chef-server.example.com/nodes/example-node
      editUrl: http://chef-server.example.com/nodes/example-node/edit
      tags:
      - example-node
      - example

### `GET /v`

Return the application version:

    1.0.0

(Yeah I lied when I said only one endpoint. Sue me.)


## Changelog

#### v1.1.1

- Return up to a million nodes

#### v1.1.0

- Even stupider: No DB

#### v1.0.0

- Stupid simple Chef-Rundeck integration