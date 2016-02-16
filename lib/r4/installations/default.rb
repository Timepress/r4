# DEFAULT SETTINGS
copy '.ruby-version'
apply 'recipes/gemfile.rb'

copy 'config/initializers/html_helpers.rb'
copy 'config/locales/cs.yml'
copy 'app/assets/stylesheets/theme.css'
copy 'app/assets/stylesheets/custom.css.scss'
copy 'app/assets/stylesheets/timepress.css.scss'

remove 'app/views/layouts/application.html.erb'
copy 'app/views/layouts/application.html.erb'

apply 'recipes/bootstrap_app.rb'
apply 'recipes/upload_app.rb'
gsub_file "#{@project_path}/lib/tasks/upload.rake", /PROJECT_DIR/, @project_name

insert_into_file "#{@project_path}/config/application.rb",
                 after: "class Application < Rails::Application\n" do <<-RUBY
      config.assets.enabled = true
      config.assets.precompile += %w()
      config.i18n.default_locale = :cs
      config.time_zone = 'Prague'
RUBY
end

apply 'recipes/mysql.rb'
apply 'recipes/rspec_generators.rb'
apply 'recipes/exception_notification.rb'
rake 'db:drop'
rake 'db:create'

apply 'recipes/devise.rb'
apply 'recipes/bootstrap.rb'
layout_file = "#{@project_path}/app/views/layouts/application.html.erb"
remove 'app/views/layouts/application.html.erb'
copy 'app/views/layouts/application.html.erb'
gsub_file layout_file, 'PROJECT_NAME', @project_name
apply 'recipes/gitignore'
run 'git init'
run 'git add .'
run "git commit -a -m 'Initial commit'"

rake 'app:bootstrap'