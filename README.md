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

You then load a document:

```ruby
require 'doc2pdf'

# passing the path
document = Doc2pdf::Document.new(file: 'my_document.doc')

# passing the file stream
document = Doc2pdf::Document.new(file: File.open('my_document.doc'))

# passing the stream of a remote resource
require 'open-uri'

document = Doc2pdf::Document.new(file: URI.open('https://mywebsite.com/my_document.doc'))
```

With the _replacer_ in place and a document, you can then replace all the placeholders in your document and produce the putput files:

```ruby
require 'doc2pdf'

replacer = # ...
document = # ...

Doc2pdf.replace_and_save!(
  document: document,
  replacer: replacer,
  output_base_path: './path/to/document'
)
```

This will produce:

- `./path/to/document.doc`
- `./path/to/document.pdf`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/xKraty/doc2pdf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/xKraty/doc2pdf/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Doc2pdf project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/xKraty/doc2pdf/blob/master/CODE_OF_CONDUCT.md).
