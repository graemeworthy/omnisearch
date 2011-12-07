# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "omni_search/version"

Gem::Specification.new do |s|
  s.name        = "omni_search"
  s.version     = OmniSearch::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Graeme Worthy"]
  s.email       = ["graeme@workben.ch"]
  s.homepage    = ""
  s.summary     = %q{OmniSearch is for providing fast intellegent results as search suggestions for sparkle}
  s.description = %q{OmniSearch, is watching you.}

  s.rubyforge_project = "omni_search"
  s.files           = Dir['lib/**/*.rb']
  #
  # s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rails"
  s.add_development_dependency "rspec"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "ZenTest"

  s.add_runtime_dependency "rails"

end
