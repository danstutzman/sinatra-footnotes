# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sinatra-footnotes/version'

Gem::Specification.new do |gem|
  gem.name          = "sinatra-footnotes"
  gem.version       = Sinatra::Footnotes::VERSION
  gem.licenses      = ['MIT']
  gem.authors       = ["Daniel Stutzman"]
  gem.email         = ["dtstutz@gmail.com"]
  gem.description   = "Every page has footnotes that give information about your application."
  gem.summary       = "Every page has footnotes that give information about your application."
  gem.homepage      = "https://github.com/danielstutzman/sinatra-footnotes"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "sinatra"
  gem.add_dependency "activesupport"
  gem.add_dependency "i18n" # needed for active_support
end
