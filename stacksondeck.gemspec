# -*- encoding: utf-8 -*-
$:.push File.expand_path(File.join('..', 'lib'), __FILE__)
require 'stacksondeck/metadata'

Gem::Specification.new do |s|
  s.name        = StacksOnDeck::NAME
  s.version     = StacksOnDeck::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = StacksOnDeck::AUTHOR
  s.email       = StacksOnDeck::EMAIL
  s.summary     = StacksOnDeck::SUMMARY
  s.description = StacksOnDeck::SUMMARY + '.'
  s.homepage    = StacksOnDeck::HOMEPAGE
  s.license     = StacksOnDeck::LICENSE

  s.add_runtime_dependency 'thor', '~> 0'
  s.add_runtime_dependency 'slog', '~> 1'
  s.add_runtime_dependency 'hashie', '~> 2'
  s.add_runtime_dependency 'sinatra', '~> 1.4'
  s.add_runtime_dependency 'ridley', '~> 4.1'

  # Bundled libs
  s.add_runtime_dependency 'eventmachine', '= %s' % StacksOnDeck::EM_VERSION
  s.add_runtime_dependency 'thin', '= %s' % StacksOnDeck::THIN_VERSION

  s.files         = Dir['{bin,lib}/**/*'] + %w[ LICENSE Readme.md VERSION ]
  s.test_files    = Dir['test/**/*']
  s.executables   = %w[ sod ]
  s.require_paths = %w[ lib ]
end