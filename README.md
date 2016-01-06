# R4

This gem is used for generating default project for Timepress company. However we hope it can be useful for other users as well.

## Installation

Add this line to your application's Gemfile:

It is still not in Rubygems repository. Thus this wont work for a while.

You can clone project and use bundler to install gem locally with "rake install".

```ruby
gem 'r4'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install r4

## Usage

Gem expects config file in home directory named .r4.yml, which should contain following:

```
mysql:
  user: 'mysql_user_name'
  password: 'mysql_password'

admin:
  login: 'default_admin_login'
  password: 'default_admin_password'
  email: 'default@admin.email'
  lastname: 'AdminLastName'

notifier:
  email: 'email@for_exception.notifier'

server:
  name: 'server_name_for_deploy_script'
  port: 'ssh_port_number'
  user: 'server_user_for_deploy'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/r4/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
