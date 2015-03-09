lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'dwml/version'

Gem::Specification.new do |s|
  s.name = "dwml"
  s.version = DWML::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Angelo Lakra"]
  s.email = ["angelo.lakra@gmail.com"]
  s.summary = "A parser for NOAA's Digital Weather Markup Language (DWML)"

  s.description = <<-EOT
   Parses DWML and outputs it into ruby arrays/hashes
  EOT

  s.homepage = "https://github.com/alakra/dwml"
  s.licenses = ['MIT']

  s.extra_rdoc_files = ['README.md']

  s.add_runtime_dependency 'nokogiri', '~> 1.6.1', '>= 1.6.1'
  s.add_runtime_dependency 'multi_json', '~> 1.11', '>= 1.11.0'
  s.add_runtime_dependency 'activesupport', '~> 4.2.0', '>= 4.2.0'

  s.required_ruby_version = '>= 1.9.3'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
end
