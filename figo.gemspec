Gem::Specification.new do |s|
  s.name        = "figo"
  s.version     = "1.4.7"
  s.authors     = ["figo GmbH", "Berend Kapelle", "Lukasz Ozimek", "Robert Kusmirek"]
  s.email       = ["bk@figo.me", "lukasz.ozimek@netguru.com", "robert.kusmirek@netguru.com"]
  s.homepage    = "https://github.com/figo-connect/ruby-figo"
  s.license     = "MIT"
  s.summary     = %q{API wrapper for figo Connect.}
  s.description = %q{Library to easily use the API of http://figo.io}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "flt"
  s.add_dependency "net-http-persistent"
end
