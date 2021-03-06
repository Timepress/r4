gemfile = "#{@project_path}/Gemfile"
gsub_file gemfile, "gem 'sqlite3'", "gem 'mysql2', '0.3.18'"

insert_into_file gemfile, after: "group :development, :test do\n" do
  <<EOF
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'timecop'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
EOF
end

insert_into_file gemfile, after: "group :development do\n" do
  <<EOF
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  gem 'bullet'
EOF
end

append_to_file gemfile do
  <<EOF
group :test do
  gem 'faker'
  gem 'capybara'
end

gem 'font-awesome-rails'
gem 'quiet_assets'
gem 'jquery-ui-rails'
EOF
end
