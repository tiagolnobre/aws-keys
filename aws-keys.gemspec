# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_keys/version'

Gem::Specification.new do |spec|
  spec.name          = "aws-keys"
  spec.version       = AwsKeys::VERSION
  spec.authors       = ["tiago"]
  spec.email         = ["tiago.nobre@mendeley.com"]
  
  spec.summary       = "Read the aws keys from Env, yml file, ~/aws/credentials"
  spec.homepage      = "https://github.com/macwadu/aws_keys"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "bump"

  spec.add_runtime_dependency "inifile", "~> 3.0"
end
