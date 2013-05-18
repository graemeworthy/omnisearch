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
    suggestions
  SUMMARY
  s.description = %q{OmniSearch, fast search for ActiveRecord models.}
  s.files           = Dir['lib/**/*.rb']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'cane'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'terminal-notifier-guard'
  s.add_development_dependency 'rb-fsevent' #for guard
  s.add_development_dependency 'timecop'

  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'memcache'
  ## will use dalli in rails 4
  ## s.add_runtime_dependency 'dalli'
  s.add_runtime_dependency 'memcache-client'

end
