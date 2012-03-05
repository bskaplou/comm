# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "comm/version"

Gem::Specification.new do |s|
  s.name        = "comm"
  s.version     = Comm::VERSION
  s.authors     = ["ezhikov"]
  s.email       = ["eshikov@mail.ru"]
  s.homepage    = ""
  s.summary     = %q{Simple queue interface pub/sub}
  s.description = %q{Simple queue interface pub/sub}

  s.rubyforge_project = "comm"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  s.add_runtime_dependency "bunny"
  s.add_runtime_dependency "yajl-ruby"
end
