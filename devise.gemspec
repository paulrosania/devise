Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'devise'
  s.version = '0.9.0'
  s.summary = "Flexible authentication solution for Rails with Warden."
  s.description = <<-EOF
    Devise is a flexible authentication solution for Rails based on Warden.
    It is Rack based; is a complete MVC solution based on Rails engines;
    allows you to have multiple roles (or models/scopes) signed in at the same time;
    and is based on a modularity concept: use just what you really need.
  EOF

  s.add_dependency('warden', '>= 0.6.4')
  s.add_dependency('rails',  '= 3.0.pre')

  s.rdoc_options = "--title", "Devise #{s.version}", "--main", "README.rdoc",
                   "--webcvs", "http://github.com/plataformatec/#{s.name}"
  s.has_rdoc = true

  s.files = Dir['CHANGELOG.rdoc', 'MIT-LICENSE', 'README.rdoc', 'Rakefile', 'TODO',
                "{app,generators,lib,test}/**/*", "devise.gemspec"]
  s.require_path = 'lib'

  s.author = "Plataforma Tec"
  s.email = "developers@plataformatec.com.br"
  s.homepage = "http://blog.plataformatec.com.br/tag/devise/"
end
