# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra-footnotes/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-footnotes"
  gem.version       = Sinatra::Footnotes::VERSION
  gem.authors       = ["Daniel Stutzman"]
  gem.email         = ["dtstutz@gmail.com"]
  gem.description   = %q{Like Jose Valim's Rails Footnotes, but for Sinatra}
  gem.summary       = %q{Like Jose Valim's Rails Footnotes, but for Sinatra}
  gem.homepage      = "https://github.com/danielstutzman/sinatra-footnotes"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra"
  gem.add_dependency "active_support", ">= 3.0.0"
  gem.add_dependency "i18n" # needed for active_support
end
