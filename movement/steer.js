// Generated by CoffeeScript 1.7.1
define(['inject', 'p2'], function(inject, p2) {
  var maxsteeringforce, _steer;
  maxsteeringforce = 1200;
  inject.bind('max steering force', maxsteeringforce);
  _steer = function(source, target, scale) {
    var steering;
    steering = [0, 0];
    p2.vec2.sub(steering, target, source);
    p2.vec2.normalize(steering, steering);
    p2.vec2.scale(steering, steering, scale);
    return steering;
  };
  inject.bind('calculate seeking', function(s, t) {
    return _steer(s, t, inject.one('max velocity'));
  });
  return inject.bind('calculate steering', function(s, t) {
    return _steer(s, t, maxsteeringforce);
  });
});
