# frozen_string_literal: true

require_relative 'lib/koralreef/version'

Gem::Specification.new do |spec|
  spec.name = 'koralreef'
  spec.version = Koralreef::VERSION
  spec.authors = ['Celo']
  spec.email = ['marcelo.mdl.dev@gmail.com']
  spec.summary = 'A tool to scrape images from websites and compile them into a PDF'
  spec.description = 'This gem provides functionality to scrape images from websites and compile them into a PDF file.'
  spec.homepage = 'https://github.com/uminocelo/koralreef'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2.0'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split('\x0').reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'bin'
  spec.executables = ['koralreef']
  spec.require_paths = ['lib']
  spec.add_dependency 'down', '~> 5.3'
  spec.add_dependency 'nokogiri', '~> 1.13'
  spec.add_dependency 'prawn', '~> 2.4'
  spec.add_dependency 'selenium-webdriver', '~> 4.1'
  spec.add_dependency 'webdrivers', '~> 5.0'
  spec.add_development_dependency 'rspec', '~> 3.11'
  spec.add_development_dependency 'rubocop', '~> 1.25'
end
