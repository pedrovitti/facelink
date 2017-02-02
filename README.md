# Facelink

Collect Facebook users interactions with Facebook pages

## Installation

    $ gem build facelink.gemspec
    $ gem install facelink-0.1.0.gem

## Configuration

    facelink configure

You will be asked for your Facebook Access Token.

## Usage

    facelink generate <file>

The file should contains a list of IDs of Facebook pages and the number of latest posts to process. An file example would be:

    305736218293232,10
    123443433440187,10
    343499393939939,15

After running this command, a new file containing user interactions will be created in the current directory.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrovitti/facelink.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

