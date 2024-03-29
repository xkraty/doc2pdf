# frozen_string_literal: true

require_relative "lib/doc2pdf/version"

Gem::Specification.new do |spec|
  spec.name          = "doc2pdf"
  spec.version       = Doc2pdf::VERSION
  spec.authors       = ["Christian Campoli", "Maurizio De Magnis"]
  spec.email         = ["christian@campoli.me", "root@olisti.co"]

  spec.summary       = "Doc2PDF"
  spec.description   = "Doc2PDF"
  spec.homepage      = "https://github.com/xkraty/doc2pdf"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "docx", "~> 0.6"
  spec.add_dependency "libreconv", "~> 0.9"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
