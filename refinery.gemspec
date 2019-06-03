# frozen_string_literal: true

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinery'
  s.version           = '2.0.0'
  s.description       = 'Aiming to provide a relatively static application foundation to reduce maintenance burden'
  s.summary           = 'An underlying framework for other systems'
  s.email             = 'gems@p.arndt.io'
  s.homepage          = 'https://github.com/refinery/refinery'
  s.authors           = ['Philip Arndt', 'Brice Sanchez']
  s.licenses          = ['Apache-2.0']
  s.require_paths     = %w[lib]

  s.files             = `git ls-files -- lib/*`.split("\n")

  s.add_dependency    'rom', '~> 5.0'
  s.required_ruby_version = '>= 2.6.3'

  s.cert_chain = [File.expand_path('certs/parndt.pem', __dir__)]
  if $PROGRAM_NAME.end_with?('gem') && ARGV == ['build', __FILE__]
    s.signing_key = File.expand_path('~/.ssh/gem-private_key.pem')
  end
end
