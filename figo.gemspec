# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "figo"
  s.version     = "0.1"
  s.authors     = ["Stefan Richter", "Michael Haller"]
  s.email       = ["stefan.richter@figo.me", "michael.haller@figo.me"]
  s.homepage    = "https://github.com/figo-connect/ruby-figo"
  s.summary     = %q{API wrapper for figo connect.}
  s.description = %q{API wrapper for figo connect.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "json"
end
