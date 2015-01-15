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
  s.add_runtime_dependency 'openstack', '~> 1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = %w[ lib ]
end