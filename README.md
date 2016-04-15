# Trexrb

Client library for Trex: I18n storage writen in Elixir

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trexrb'
```

## Usage

```ruby

# this probably goes into an initializer
I18n.backend = Trex::Backend.new
I18n.available_locales = :en

# .. and then it can be used through rails
I18n.backend.store_translations :en, :foo => { :bar => :baz }
puts I18n.t "foo" #=> { :bar => :baz }

```


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
