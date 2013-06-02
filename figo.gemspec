Gem::Specification.new do |s|
  s.name        = "figo"
  s.version     = "1.0"
  s.authors     = ["Stefan Richter", "Michael Haller"]
  s.email       = ["stefan.richter@figo.me", "michael.haller@figo.me"]
  s.homepage    = "https://github.com/figo-connect/ruby-figo"
  s.summary     = %q{API wrapper for figo Connect.}
  s.description = %q{API wrapper for figo Connect.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "flt"
  s.add_dependency "net-http-persistent"
end
