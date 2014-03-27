# PrimeSlidingAction

Add sliding action cells support to MotionPrime.

## Installation

Add this line to your application's Gemfile:

    gem 'prime_sliding_action'

## Usage

```
class MyCellSection < Prime::Section
  add_sliding_action_button :like, 
    text_color: :white, 
    background_color: :red,
    title: 'Like', 
    action: :action_like

  def action_like
    puts "Like!"
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks for using PrimeSlidingAction!

Hope, you'll enjoy PrimeSlidingAction!

Cheers, [Droid Labs](http://droidlabs.pro).