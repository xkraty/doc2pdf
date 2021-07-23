# Doc2pdf

Given a `.doc` file containing some placeholders in the form of the pattern `{placeholder_here}` and a _replacement_ strategy (a mapping between placeholder texts and the content to be inserted), it applies the replacements and converts the document into a `.pdf`.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'doc2pdf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install doc2pdf

## Usage

First of all you have to implement a _replacer_, that is an object that responds to the `call` method and accepts a `key` argument. Its purpose is to provide the replacement for every keyword passed.

This is just a very simple implementation of such _replacer_:

```ruby
class BasicReplacer
  def call(key:)
    case key
    when 'foo' then 'Fooing'
    when 'bar' then 'Baring'
    else
      raise 'keyword unknown'
    end
  end
end

replacer = BasicReplacer.new
replacer.call(key: 'foo') # => 'Fooing'
replacer.call(key: 'spam') # => RuntimeError (keyword unknown)
```

But you can also provide a more exotic implementation:

```ruby
class DynamicReplacer
  def initialize(resource)
    @resource = resource
  end

  def call(key:)
    send(key)
  end

  private

  def method_missing(m, *args, &block)
    m.to_s.split('.').inject(@resource) do |memo, method_name|
      memo.send(method_name)
    end
  end
end

replacer = DynamicReplacer.new('Foo')
replacer.call(key: 'length.class.to_s.length') # => 7
replacer.call(key: 'asd') # => NoMethodError (undefined method `asd' for "Foo":String)
```

Pick you poison. 😄

With the _replacer_ in place, you can then replace all the placeholders in your document and produce the output files:

```ruby
require 'doc2pdf'

replacer = # ...

# You can specify a local file or a remote one:
file_or_url = 'input.docx'
file_or_url = 'https://domain.com/docs/input.docx'

Doc2pdf.replace_and_save!(
  file: file_or_url,
  replacer: replacer,
  output_path: './path/to/document.pdf'
)
```

## Tempfiles

Suppose you need to use a tempfile also for the output:

```ruby
file_or_url = 'https://domain.com/docs/input.docx'
outfile = Tempfile.new

Doc2pdf.replace_and_save!(
  file: file_or_url,
  replacer: replacer,
  output_path: outfile.path
)
```

Here you can use `outfile` for anything you want.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xKraty/doc2pdf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/xKraty/doc2pdf/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Doc2pdf project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xKraty/doc2pdf/blob/master/CODE_OF_CONDUCT.md).
