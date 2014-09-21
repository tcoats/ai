// Generated by CoffeeScript 1.7.1
define(['inject', 'p2'], function(inject, p2) {
  inject.bind('anticlockwise', (function(_this) {
    return function(vec) {
      return [-vec[1], vec[0]];
    };
  })(this));
  return inject.bind('clockwise', (function(_this) {
    return function(vec) {
      return [vec[1], -vec[0]];
    };
  })(this));
});
