define ['inject', 'p2'], (inject, p2) ->
  maxsteeringforce = 1200
  
  inject.bind 'max steering force', maxsteeringforce
  
  _steer = (source, target, scale) ->
    steering = [0, 0]
    p2.vec2.sub steering, target, source
    p2.vec2.normalize steering, steering
    p2.vec2.scale steering, steering, scale
    steering

  inject.bind 'calculate seeking', (s, t) ->
    _steer s, t, inject.one 'max velocity'

  inject.bind 'calculate steering', (s, t) ->
    _steer s, t, maxsteeringforce
