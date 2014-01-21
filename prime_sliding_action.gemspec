require File.expand_path('../lib/prime_sliding_action/version.rb', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "prime_sliding_action"
  spec.version       = PrimeSlidingAction::VERSION
  spec.authors       = ["Iskander Haziev"]
  spec.email         = ["gvalmon@gmail.com"]
  spec.description   = %q{Add sliding action cells support to MotionPrime.}
  spec.summary       = %q{Add sliding action cells support to MotionPrime.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + ["README.md"]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "cocoapods"
  spec.add_dependency "motion-cocoapods"
  spec.add_dependency "motion-require"
end
