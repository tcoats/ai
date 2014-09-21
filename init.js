// Generated by CoffeeScript 1.7.1
requirejs.config({
  paths: {
    p2: 'lib/p2.min'
  }
});

define('plugins', ['statistics', 'ai', 'physics', 'display']);

define('game', ['inject', 'plugins'], function(inject) {
  var ai, createunit, display, phys, stats, _, _i;
  ai = inject.one('register ai');
  stats = inject.one('register statistics');
  phys = inject.one('register physics');
  display = inject.one('register display');
  createunit = function(u, brain) {
    var motif;
    motif = brain;
    if (u.neo != null) {
      motif = 'neo';
    }
    ai(u, "brains/" + brain);
    stats(u);
    phys(u, 'person', [random(width), random(height)], [0, 0]);
    return display(u, motif);
  };
  for (_ = _i = 0; _i <= 49; _ = ++_i) {
    createunit({}, 'unit');
  }
  window.neo = {
    neo: true
  };
  return createunit(window.neo, 'unit');
});

window.setup = function() {
  createCanvas(windowWidth, windowHeight);
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
