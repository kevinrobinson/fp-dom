# JSON ops

# Object -> Op -> Object
applyOp: (obj) -> (op) ->
  [path, action] = op
  target = followPath(path)(obj)
  performAction(action)(target)

# Step -> Object -> Object
followPath: (path) -> (obj) ->
  [step, stepsTail...] = path.split '.'
  nextObj = obj[head]
  if stepsTail.length is 0
    nextObj
  else
    followPath(tail)(obj[head])

# Action -> Object -> Object
performAction: (action) -> (obj) ->
  [type, params...] = action
  switch type
    when 'push'
      [item] = params 
      obj.concat item
    when 'remove'
      [item] = params
      _.without obj, item
    when 'swap'
      [a, b] = params
      clone = _.clone(obj, true)
      c = clone[a]
      clone[a] = clone[b]
      clone[b] = c
      clone
    when 'set'
      [key, value] = params
      clone = _.clone(obj, true)
      clone[key] = value
      clone
    when 'delete'
      [key] = params
      clone = _.clone(obj, true)
      delete clone[key]
      clone
    else
      undefined