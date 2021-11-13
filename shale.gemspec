# frozen_string_literal: true

require_relative 'lib/shale/version'

Gem::Specification.new do |spec|
  spec.name = 'shale'
  spec.version = Shale::VERSION
  spec.authors = ['Kamil Giszczak']
  spec.email = ['beerkg@gmail.com']

  spec.summary = 'Object mapper/serializer for XML/JSON/YAML.'
  spec.description = 'Object mapper/serializer for XML/JSON/YAML.'
  spec.homepage = 'https://github.com/kgiszczak/shale'
  spec.license = 'MIT'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = 'https://github.com/kgiszczak/shale'
  spec.metadata['source_code_uri'] = 'https://github.com/kgiszczak/shale'
  spec.metadata['changelog_uri'] = 'https://github.com/kgiszczak/shale/blob/master/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/kgiszczak/shale/issues'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6.0'
end
