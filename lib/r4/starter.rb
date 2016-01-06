require 'thor'
require_relative 'odin'
require_relative 'config'

class Starter < Thor
  include Thor::Actions
  include Odin

  def initialize(*args)
    super
    if ARGV[0] =~ /new/
      @dir = `pwd`.gsub("\n", '')
    elsif ARGV[0] =~ /add/
      if yes? 'Are you in right folder of your app?'
        @project_path = `pwd`
        @project_name = @project_path.split('/').last
        @project_label = @project_name.capitalize.gsub('_', ' ')
      else
        say 'Get to proper directory', :red
        abort
      end
    end
  end

  desc 'new PROJECT_NAME', 'install rails application with asking you about stuff'
  method_options alias: :string, ask: :string
  def new project_name
    @project_name = project_name
    run "rails new #{@project_name} -T --skip-bundle"

    @project_path = "#{@dir}/#{@project_name}"
    @project_label = @project_name.capitalize.gsub('_', ' ')

    Dir.chdir @project_path

    # DEFAULT SETTINGS
    copy '.ruby-version'
    # TODO use Gemfile created by RAILS, same for gitignore
    remove "Gemfile"
    copy 'Gemfile'
    copy 'config/initializers/html_helpers.rb'
    copy 'config/locales/cs.yml'
    copy 'app/assets/stylesheets/theme.css'
    copy 'app/assets/stylesheets/custom.css.scss'
    copy 'app/assets/stylesheets/timepress.css.scss'

    remove 'app/views/layouts/application.html.erb'
    copy 'app/views/layouts/application.html.erb'

    remove '.gitignore'
    copy '.gitignore'
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

    unless options[:ask]
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

    else
      if yes? 'Do you want to prepare database config for mysql?'
        apply 'recipes/mysql.rb'
      end

      if yes? 'Do you want to add rspec generators to application.rb?'
        apply 'recipes/rspec_generators.rb'
      end

      if yes? 'Do you want to add exception notification?'
        apply 'recipes/exception_notification.rb'
      end

      if yes? 'do you want to drop and create a database?'
        rake 'db:drop'
        rake 'db:create'
      end

      if yes? 'Do you want to add devise to project?'
        apply 'recipes/devise.rb'
      end
    end

    run 'git init'
    run 'git add .'
    run "git commit -a -m 'Initial commit'"

    rake 'app:bootstrap'

    # for testing project starter
    run "rails g scaffold Article name:string body:text"
    rake "db:migrate"
  end


  # functions to add funcionality to existing project
  # TODO not tested at all!!!

  desc 'add_wicked_pdf', 'add pdf generation to project'
  def add_wicked_pdf
    add_gem 'wicked_pdf'
    add_gem 'wkhtmltopdf-binary'
    run 'bundle install'
    run 'rails generate wicked_pdf'
    # TODO fix initializer
  end

  # TODO any reason not to use bootstrap?
  desc 'add_bootstrap', 'add bootstrap to project'
  def add_bootstrap
    apply 'recipe/bootstrap.rb'
  end

  desc 'add_xlsx_support', 'add gems for working with excel files'
  def add_xlsx_support
    say 'Not ready yet!', :red
    #gem 'roo'
    #gem 'axlsx', '~> 2.0.1' # problems with newest version of RubyZip
  end

  desc 'add_mail_support', 'add gems for working with mail'
  def add_mail_gem
    say 'Not ready yet!', :red
    #gem 'mail'
  end

  desc 'add_in_place_editing_support', 'add gems for in place editing'
  def add_best_in_place
    say 'Not ready yet!', :red
    #gem 'best_in_place'
  end

  desc 'add_charts_support', 'add gems for charts creating'
  def add_lazy_charts
    say 'Not ready yet!', :red
    #gem 'lazy_high_charts'
  end

  desc 'add_datatables', 'add gems for datatables'
  def add_datatables
    say 'Not ready yet!', :red
    #gem 'jquery-datatables-rails', '~> 2.2.3'
  end

  desc 'add_skylight', 'add gems for skylight reporting'
  def add_skylight
    say 'Not ready yet!', :red
    #gem 'skylight'
  end

  desc 'add_devise', 'add devise authentication to project'
  def add_devise
    apply 'recipes/devise.rb'
  end

  desc 'add_exception_notification', 'add exception notification to project'
  def add_exception_notification
    apply 'recipes/exception_notification.rb'
  end

  # local helpers
  no_commands do
    def source_paths
      root_path = File.dirname __FILE__
      [root_path + '/template', root_path]
    end

    def copy filename
      copy_file filename, "#{@project_path}/#{filename}"
    end

    def remove filename
      remove_file "#{@project_path}/#{filename}"
    end

    def add_gem name
      append_to_file "#{@project_path}/Gemfile" do
        "\ngem '#{name}'"
      end
    end
  end

end