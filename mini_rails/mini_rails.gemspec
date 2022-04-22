$:.push File.expand_path("../", __FILE__)

Gem::Specification.new do |s|
  s.name        = 'mini_rails'
  s.version     = '0.0.2'
  s.date        = '2020-04-04'
  s.summary     = 'MiniRails'
  s.description = 'MiniRails'
  s.author      = 'Vladislav Kopylov'
  s.email       = 'kopylov.vlad@gmail.com'
  s.homepage    = 'https://github.com/kopylovvlad/'
  s.license     = 'MIT'
  s.files       = `git ls-files`.split("\n")
  s.add_dependency('rack')
  s.add_dependency('rack-test')
end
