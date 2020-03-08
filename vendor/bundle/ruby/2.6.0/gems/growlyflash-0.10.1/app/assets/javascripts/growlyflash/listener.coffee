class Listener
  # Alerts stack
  class Stack
    constructor: (@items...) ->

    purge: ->
      setTimeout (=> @items.splice(0)), 100

    push: (alert, dumped) ->
      dumped ?= alert.toString()
      console.log("Add to Growlyflash stack: ", dumped) if Growlyflash.debug
      Growlyflash.growl(alert)
      @items.push(dumped)

    push_only_fresh: (alerts) ->
      recent = @items[-alerts.length..]
      for alert in alerts
        dumped = alert.toString()
        @push(alert, dumped) if dumped not in recent
      do @purge

  @HEADER = 'X-Message'
  @EVENTS = 'ajax:complete ajaxComplete'

  process = (alerts = {}) ->
    new Growlyflash.FlashStruct(msg, type) for type, msg of alerts when msg?

  process_from_header = (source) ->
    return [] unless source?
    process $.parseJSON(decodeURIComponent(source))

  constructor: (context) ->
    @stack ?= new Stack()
    @process_static(context)
    ($ context).on Growlyflash.Listener.EVENTS, (event, xhr) =>
      if xhr ?= event.data?.xhr
        source = process_from_header(xhr.getResponseHeader(Growlyflash.Listener.HEADER))
        @stack.push_only_fresh source
      return

  process_static: (context)->
    if tag = context.getElementById('growlyflash-tag')
      tag_flashes = JSON.parse(tag.getAttribute('data-flashes'))
      @stack.push alert for alert in process(tag_flashes)
    else if window.flashes?
      @stack.push alert for alert in process(window.flashes)
      delete window.flashes 

@Growlyflash.Listener = Listener
@Growlyflash.listen_on = (context) ->
  @listener ?= new @Listener(context)
