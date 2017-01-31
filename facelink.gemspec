# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'facelink/version'

Gem::Specification.new do |spec|
  spec.name          = "facelink"
  spec.version       = Facelink::VERSION
  spec.authors       = ["Pedro Vitti"]
  spec.email         = ["pedrovitti@gmail.com"]

  spec.summary       = "Collect Facebook users interactions with a given Facebook page."
  spec.homepage      = "https://github.com/pedrovitti/spregen'"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.executables   = ["facelink"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "koala", "2.4.0"

  spec.add_runtime_dependency "commander", "4.4.3"
end
