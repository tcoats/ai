// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

define(['inject', 'colors'], function(inject, colors) {
  var Display;
  Display = (function() {
    function Display() {
      this.register = __bind(this.register, this);
      this.unit = __bind(this.unit, this);
      this.boid = __bind(this.boid, this);
      this.step = __bind(this.step, this);
      this.entities = [];
      inject.bind('step', this.step);
      inject.bind('register display', this.register);
    }

    Display.prototype.step = function() {
      var entity, _i, _len, _ref, _results;
      background(colors.bg);
      _ref = this.entities;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        entity = _ref[_i];
        if (this[entity.n] != null) {
          _results.push(this[entity.n](entity.e()));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };

    Display.prototype.boid = function(e) {
      var color;
      fill(colors.bg);
      color = colors.blue;
      if (e.stats.iscommunity) {
        color = colors.red;
      }
      if (e.stats.timesincetouch < 10) {
        color = colors.gold;
      }
      stroke(color);
      return ellipse(e.phys.b.position[0], e.phys.b.position[1], 16, 16);
    };

    Display.prototype.unit = function(e) {
      var t, _i, _len, _ref;
      fill(colors.bg);
      if (e.neo != null) {
        if (e.targets != null) {
          stroke(colors.red);
          _ref = e.targets;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            t = _ref[_i];
            ellipse(t.t[0], t.t[1], 16, 16);
          }
        }
        if (e.target != null) {
          stroke(colors.grey);
          ellipse(e.target[0], e.target[1], 16, 16);
        }
        stroke(colors.gold);
        ellipse(e.phys.b.position[0], e.phys.b.position[1], 16, 16);
        if (e.target != null) {
          line(e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]);
        }
        return;
      }
      stroke(colors.blue);
      ellipse(e.phys.b.position[0], e.phys.b.position[1], 16, 16);
      if (e.target != null) {
        return line(e.phys.b.position[0], e.phys.b.position[1], e.target[0], e.target[1]);
      }
    };

    Display.prototype.register = function(entity, name) {
      entity.d = {
        n: name,
        e: function() {
          return entity;
        }
      };
      return this.entities.push(entity.d);
    };

    return Display;

  })();
  return new Display();
});
