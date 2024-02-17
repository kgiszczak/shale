# frozen_string_literal: true

require_relative 'lib/shale/version'

Gem::Specification.new do |spec|
  spec.name = 'shale'
  spec.version = Shale::VERSION
  spec.authors = ['Kamil Giszczak']
  spec.email = ['beerkg@gmail.com']

  spec.summary = 'Ruby object mapper and serializer for XML, JSON, TOML, CSV and YAML.'
  spec.description = 'Ruby object mapper and serializer for XML, JSON, TOML, CSV and YAML.'
  spec.homepage = 'https://shalerb.org'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = 'https://shalerb.org'
  spec.metadata['source_code_uri'] = 'https://github.com/kgiszczak/shale'
  spec.metadata['changelog_uri'] = 'https://github.com/kgiszczak/shale/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/kgiszczak/shale/issues'

  spec.files = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'shale.gemspec', 'lib/**/*']
  spec.require_paths = ['lib']

  spec.bindir = 'exe'
  spec.executables = 'shaleb'

  spec.add_runtime_dependency 'bigdecimal'

  spec.required_ruby_version = '>= 3.0.0'
end
