# Model -> DOM element -> Unit
renderImperative = (model, el) ->
  $(el).html('<DIV class="container"><BUTTON class="add">Add</BUTTON><BUTTON class="remove">Remove</BUTTON></DIV>')
  $(el).css border: '1px solid black'
  $(el).delegate 'BUTTON.add', 'click', (e) ->
    console.log 'click'
    model.items.push 'new item'


# Model -> DOM element -> List[Mutation]
renderFunctional = (model) ->
  [
    ['html', '<DIV class="container"><BUTTON class="add">Add</BUTTON><BUTTON class="remove">Remove</BUTTON></DIV>']
    ['css', 'border', '1px solid black']
    ['delegate', 'BUTTON.add', 'click', (e) -> model.items.push 'new item']
  ]


# List[Mutation] -> DOM element -> Unit (applying side effects to the DOM)
interpretRenderFunctional = (mutations) -> (el) ->
  for mutation in mutations
    [method, args...] = mutation
    $(el)[method](args...)
    console.log method, args
  undefined




# This is sugar to let us write normal jQuery imperative code, and have it
# be captured as a data structure for later interpretation.  Only a small sample
# of jQuery functions here.
jq = (fn, context) ->
  operations = []
  proxy = (selector) ->
    find: (findSelector) ->
      operations.push [selector, 'find', findSelector]
      proxy(selector + ' ' + findSelector)
    html: (params...) ->
      operations.push [selector, 'html', params...]
      proxy(selector)
    css: (params...) ->
      operations.push [selector, 'css', params...]
      proxy(selector)
    delegate: (params...) ->
      operations.push [selector, 'delegate', params...]
      proxy(selector)
  fn.call(context, proxy)
  operations


# Usage:
jq ($) ->
  $('BUTTON.add').find('DIV.oh').html 'uh oh'
  $('BUTTON.add').delegate 'BUTTON', 'click', (e) -> console.log('clickccc')
  $('BUTTON.remove').css 'display', 'none'