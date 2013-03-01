# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'omni_search/version'

Gem::Specification.new do |s|
  s.name        = 'omni_search'
  s.version     = OmniSearch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Graeme Worthy']
  s.email       = ['graeme@workben.ch']
  s.homepage    = ''
  s.summary     = <<-SUMMARY
    OmniSearch is for providing fast intellegent results as search
    suggestions for sparkle
  SUMMARY
  s.description = %q{OmniSearch, is watching you.}
  s.files           = Dir['lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'ZenTest'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'memcache'
  s.add_development_dependency 'memcache-client'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'terminal-notifier-guard'
  s.add_development_dependency 'rb-fsevent' #for guard

  s.add_runtime_dependency 'activesupport'

end
