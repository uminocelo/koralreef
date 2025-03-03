# Koral Reef

A Ruby gem that scrapes images from websites (including JavaScript-heavy ones) and compiles them into a PDF.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'koralreef'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install koralreef
```

## Usage

### Command Line

```bash
# Basic usage (scrapes all images)
$ koralreef https://example.com/gallery

# Scrape specific images with a CSS selector
$ koralreef -s ".product-image" https://example.com/products

# Specify output file
$ koralreef -o product_catalog.pdf https://example.com/products

# Run with visible browser (not headless)
$ koralreef --no-headless https://example.com/gallery
```

### In Ruby Code

```ruby
require 'koralreef'

# Basic usage
pdf_file = Koralreef.run(
  url: "https://example.com/gallery",
  selector: "img.gallery-image",
  output_file: "gallery.pdf",
  headless: true
)

puts "PDF created at: #{pdf_file}"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/uminocelo/koralreef.

## License

The gem is available as open source under the terms of the MIT License.