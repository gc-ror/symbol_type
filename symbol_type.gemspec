# frozen_string_literal: true

require_relative 'lib/symbol_type/version'

Gem::Specification.new do |spec|
  spec.name = 'symbol_type'
  spec.version = SymbolType::VERSION
  spec.authors = ['t-hane']
  spec.email = ['t-hane@gc-story.com']

  spec.summary = 'Offers SymbolType for ActiveModel'
  spec.description = 'Offers SymbolType for ActiveModel.'
  spec.homepage = 'https://gc-story.com/'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://github.com/gc-ror'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/gc-ror/symbol_type'
  spec.metadata['changelog_uri'] = 'https://github.com/gc-ror/symbol_type/releases'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord'
end
