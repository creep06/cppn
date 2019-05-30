source 'https://rubygems.org'
# なぜかbuildpackが存在しないって言われるからver指定してない
# ruby '2.5.0'
gem 'rails'
gem 'puma'
gem 'bootsnap', require: false
gem 'capistrano', require: false

gem 'rb-readline'
gem 'dotenv-rails'
gem 'whenever', :require => false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'sqlite3'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

#gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
