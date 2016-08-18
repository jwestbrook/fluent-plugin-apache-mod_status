# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-apache_modstatus"
  spec.version       = '0.0.5'
  spec.authors       = ["Jason Westbrook"]
  spec.email         = ["jwestbrook@gmail.com"]

  spec.summary       = %q{Gather the status from the Apache mod_status Module}
  spec.homepage      = "https://github.com/jwestbrook/fluent-plugin-apache_modstatus"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fluentd", [">= 0.10.30", "< 2"]
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
