# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'roadblock/version'

Gem::Specification.new do |spec|
  spec.name          = "roadblock"
  spec.version       = Roadblock::VERSION
  spec.authors       = ["Shane Emmons", "Emily Dobervich"]
  spec.email         = ["oss@teamsnap.com"]
  spec.description   = <<DESC
Roadblock provides a simple interface for checking if a ruby object has the
authority to interact with another object. The most obvious example being if
the current user in your rails controller can read/write the object they're
attempting to access.
DESC
  spec.summary       = "A simple authorization library."
  spec.homepage      = "https://github.com/teamsnap/roadblock"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.0.0.beta1"
end
