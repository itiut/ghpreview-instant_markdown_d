# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghpreview/instant_markdown_d/version'

Gem::Specification.new do |spec|
  spec.name          = "ghpreview-instant_markdown_d"
  spec.version       = GHPreview::InstantMarkdownD::VERSION
  spec.authors       = ["Yuichi TANIKAWA"]
  spec.email         = ["t.yuichi111@gmail.com"]
  spec.summary       = %q{Small server running ghpreview compatible with instant-markdown-d}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'ghpreview'
  spec.add_dependency 'rack'
  spec.add_dependency 'thin'
  spec.add_dependency 'faye-websocket'

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
