source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.1'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

gem 'acts_as_api', '~> 1.0', '>= 1.0.1'
gem 'consul', '~> 1.0', '>= 1.0.3'
gem 'enumerize', '~> 2.4'
gem 'smart_error', '~> 1.0', '>= 1.0.3'
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'httplog', '~> 1.4', '>= 1.4.3'
  gem 'rubocop', '~> 1.7'
  gem 'pry-rails', '~> 0.3.9'
  gem 'annotate', '~> 3.1', '>= 3.1.1'
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
