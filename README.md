# attachmentgenie-flink

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with flink](#setup)
    * [What flink affects](#what-flink-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with flink](#beginning-with-flink)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Module Description

Flink’s core is a streaming dataflow engine that provides data distribution, communication,
and fault tolerance for distributed computations over data streams.

## Setup

### What flink affects

- Configuration files and directories (created and written to)
- Package/service/configuration files for Flink
- Listened-to ports

### Setup Requirements

This module expects that the system already has a working java installation.

### Beginning with flink

To have Puppet install Flink with the default parameters, declare the flink class:

``` puppet
class { 'flink': }
```

You can customize parameters when declaring the `flink` class. For instance,
 this declaration installs Flink by downloading a tarball instead of instead of using a package.

``` puppet
class { '::flink':
  archive_source => 'http://apache.xl-mirror.nl/flink/flink-1.1.4/flink-1.1.4-bin-hadoop27-scala_2.11.tgz',
  install_method => 'archive',
}
```

## Limitations

This module currently only install a all in one version.

## Development

### Running tests

This project contains tests for both [rspec-puppet][] and [test kitchen][] to verify functionality. For detailed information on using these tools, please see their respective documentation.

#### Testing quickstart:

```
gem install bundler
bundle install
bundle exec rake guard
bundle exec kitchen test