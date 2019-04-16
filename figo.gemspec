Gem::Specification.new do |s|
  s.name        = "figo"
  s.version     = "1.4.2"
  s.authors     = ["figo GmbH"]
  s.email       = ["devs@figo.io"]
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
