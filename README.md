[![Build Status](https://travis-ci.org/macwadu/aws_keys.svg?branch=master)](https://travis-ci.org/macwadu/aws_keys)
[![GitHub version](https://badge.fury.io/gh/macwadu%2Faws_keys.svg)](http://badge.fury.io/gh/macwadu%2Faws_keys)

# AwsKeys

Read the aws keys from ENV, yml file and ~/aws/credentials

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws-keys'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws-keys

## Usage

### Use environment variables
```ruby
ENV["AWS_ACCESS_KEY"]="my_access_key"
ENV["AWS_SECRET_KEY"]="my_secret_key"

AwsKeys.load
=> {"aws_access_key"=>"my_access_key", "aws_secret_key"=>"my_secret_key"}
```

### Use yml file

File: ~/.aws.yml
```yaml
---
aws_access_key: my_access_key
aws_secret_key: my_secret_key
```

```ruby
AwsKeys.load
=> {"aws_access_key"=>"my_access_key", "aws_secret_key"=>"my_secret_key"}
```
### Use ini ~/aws/credentials file

File: ~/aws/credentials
```ini
[default]
aws_access_key = my_access_key
aws_secret_key = my_secret_key

[admin]
aws_access_key = admin_access_key
aws_secret_key = admin_secret_key
```

```ruby
AwsKeys.load
=> {"aws_access_key"=>"my_access_key", "aws_secret_key"=>"my_secret_key"}

AwsKeys.load(profile: "admin")
=> {"aws_access_key"=>"admin_access_key", "aws_secret_key"=>"admin_secret_key"}

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/aws-keys/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
