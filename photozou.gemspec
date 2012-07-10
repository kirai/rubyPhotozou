# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "photozou/0.1"

Gem::Specification.new do |s|
  s.name        = "photozou"
  s.version     = Mygem::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Hector Garcia"]
  s.email       = ["hectorkirai@gmail.com"]
  s.homepage    = "http://www.kirainet.com"
  s.summary     = %q{Photozou Api}
  s.description = %q{Photozou Api wrapper. Supports basic auth, GET and POST multipart requests}

  s.add_development_dependency "rspec", "~>2.5.0"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
