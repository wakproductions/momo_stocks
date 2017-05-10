ruby '2.4.1'
source 'https://rubygems.org'

gem 'rails',          '~> 5.1'
gem 'pg',             '~> 0.20'
gem 'puma',           '~> 3.7'

gem 'coffee-rails',   '~> 4.2'
gem 'haml'
gem 'jbuilder',       '~> 2.5'
gem 'jquery-rails'
gem 'sass-rails',     '~> 5.0'
gem 'turbolinks',     '~> 5'
gem 'uglifier',       '>= 1.3.0'

# Utility and design pattern enhancing gems
# gem 'figaro',         '~> 1.1.1'  # Don't need this quite yet
gem 'verbalize',      '~> 2.0'  # Does same as Actionizer, but benchmarks faster. Considering replacing actionizer

# Other useful utilities
# gem 'colorize',       '~> 0.8.1' # Not using yet

group :development, :test do
  gem 'rspec-rails',      '~> 3.5'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'webmock',          '~> 2.1'

  gem 'byebug', platform: :mri
  gem 'pry',        '~> 0.10.4'
  gem 'pry-rails',  '~> 0.3.4'
  gem 'pry-byebug', '~> 3.4'

  gem 'clipboard',  '~> 1.1.1'
end

group :development do
  gem 'web-console'
  gem 'listen', '~> 3.0.5'

  gem 'capistrano',         '3.6.1'
  gem 'capistrano3-puma'
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
end


