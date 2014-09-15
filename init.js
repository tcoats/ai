// Generated by CoffeeScript 1.7.1
define('plugins', ['statistics', 'ai', 'physics', 'display']);

define('game', ['inject', 'plugins'], function(inject) {
  var chosenone, u, _, _i;
  for (_ = _i = 0; _i <= 99; _ = ++_i) {
    u = {};
    inject.one('register ai')(u, 'unit');
    inject.one('register statistics')(u);
    inject.one('register physics')(u, 'unit', [random(width), random(height)], [0, 0]);
    inject.one('register display')(u, 'unit');
  }
  chosenone = {
    neo: true
  };
  inject.one('register ai')(chosenone, 'unit');
  inject.one('register statistics')(chosenone);
  inject.one('register physics')(chosenone, 'unit', [random(width), random(height)], [0, 0]);
  inject.one('register display')(chosenone, 'unit');
});

window.setup = function() {
  createCanvas(windowWidth, windowHeight);
  requirejs.config({
    urlArgs: 'v=' + (new Date()).getTime(),
    paths: {
      p2: 'p2.min'
    }
  });
  return requirejs(['inject', 'game'], function(inject) {
    var render, setup, _i, _len, _ref;
    _ref = inject.many('setup');
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      setup = _ref[_i];
      setup();
    }
    render = true;
    window.draw = function() {
      var step, _j, _len1, _ref1, _results;
      if (!render) {
        return;
      }
      _ref1 = inject.many('step');
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        step = _ref1[_j];
        _results.push(step());
      }
      return _results;
    };
    return window.mousePressed = function() {
      return render = !render;
    };
  });
};
