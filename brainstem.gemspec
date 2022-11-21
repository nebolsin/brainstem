# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require "brainstem/version"

Gem::Specification.new do |gem|
  gem.name          = "brainstem"
  gem.authors       = ["Mavenlink"]
  gem.email         = ["opensource@mavenlink.com"]
  gem.description   = %q{Brainstem allows you to create rich API presenters that know how to filter, sort, and include associations.}
  gem.summary       = %q{ActiveRecord presenters with a rich request API}
  gem.homepage      = "http://github.com/mavenlink/brainstem"
  gem.license       = "MIT"

  gem.files         = Dir["**/*"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.version       = Brainstem::VERSION

  gem.executables   << 'brainstem'

  gem.add_dependency "activerecord", ">= 4.2", "< 8.0"
  gem.add_dependency "activesupport", ">= 4.2", "< 8.0"
end
