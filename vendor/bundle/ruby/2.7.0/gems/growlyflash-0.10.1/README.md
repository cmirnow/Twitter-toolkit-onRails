# Growlyflash

The growlyflash gem turns boring [ActionDispatch::Flash](http://api.rubyonrails.org/?q=ActionDispatch::Flash) messages in your Rails app to asynchronous Growl-like notifications with [Bootstrap Alert](http://getbootstrap.com/components/#alerts) markup.

With XHR requests it places flash hash to the `X-Messages` HTTP header or inline in javascript.

Based on rewritten in coffeescript [Bootstrap Growl](https://github.com/ifightcrime/bootstrap-growl) plugin and inspired by [Bootstrap Flash Messages](https://github.com/RobinBrouwer/bootstrap_flash_messages)

## Update from versions below 0.5.0

Warning! Current version breaks integration from older releases, so, if you want to update, you should check installation and customization steps again.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'growlyflash'
```

Require one of the following Growlyflash javascripts depending on your Bootstrap version in `app/assets/javascripts/application.js`:

For Bootstrap 3

```js
//= require growlyflash
```

For Bootstrap 2

```js
//= require growlyflash.bs2
```

Import Growlyflash style in `app/assets/stylesheets/application.css.scss` after importing Bootstrap styles:

```scss
@import "growlyflash";
```

To use text flash messages as growl notifications with XHR request, add `use_growlyflash` to your controllers (usually `application_controller.rb`). This is a shorthand for `append_after_action :flash_to_header, if: "request.xhr?"` and takes callback parameters like `only`, `except`, `if` or `unless`:

```ruby
use_growlyflash # except: %i[actions without growlyflash]

# Also there is another shorthand, to skip callbacks:
# skip_growlyflash only: %i[actions without growlyflash]
```

To make notifications also available with non-XHR requests, insert the following line into your layout template inside `<head>` tag before any other javascript:

```erb
<%= growlyflash_static_notices %>
```

If you want your website to be compliant with Content-Security-Policy, and
especially avoid `script-src: 'unsafe-inline'`, you can use another helper to
render an html tag with data attributes instead of injecting javascript code
into your page:

```erb
<%= growlyflash_tag %>
```


## Customize

If you want to change default options, you can override them somewhere in your coffee/js:

```coffee
Growlyflash.defaults = $.extend on, Growlyflash.defaults,
  align:   'right'  # horizontal aligning (left, right or center)
  delay:   4000     # auto-dismiss timeout (0 to disable auto-dismiss)
  dismiss: yes      # allow to show close button
  spacing: 10       # spacing between alerts
  target:  'body'   # selector to target element where to place alerts
  title:   no       # switch for adding a title
  type:    null     # bootstrap alert class by default
  class:   ['alert', 'growlyflash', 'fade']
```

Also you can override few style variables before the `@import` directive (or just manually override styles ([look at _growlyflash.scss](app/assets/stylesheets/_growlyflash.scss)):

```scss
$growlyflash-top:     20px !default;
$growlyflash-side:    20px !default;
$growlyflash-width:   auto !default;
$growlyflash-zindex:  9999 !default;

@import "growlyflash";
```

Insert the following if you want to close alert boxes by clicking on themselves.
Also it doesn't steel focus from toggled elements like dropdowns and works fine with touch devices, so I advise to use it:

```coffee
jQuery ->
  $(document).on "touchstart.alert click.alert", ".growlyflash", (e) ->
    e.stopPropagation()
    ($ @).alert 'close'
    off
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
