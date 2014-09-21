// Generated by CoffeeScript 1.7.1
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

define(['inject', 'p2'], function(inject, p2) {
  var Unit;
  return Unit = (function() {
    function Unit(entity, n) {
      this.square = __bind(this.square, this);
      this.lineup = __bind(this.lineup, this);
      this.boid = __bind(this.boid, this);
      this.fuzzy = __bind(this.fuzzy, this);
      this.step = __bind(this.step, this);
      this.e = entity;
      this.n = n;
    }

    Unit.prototype.step = function() {
      return this.fuzzy();
    };

    Unit.prototype.fuzzy = function() {
      var direction;
      direction = [random(2) - 1, random(2) - 1];
      p2.vec2.scale(direction, direction, 1000);
      inject.one('apply force')(this.e, direction);
      inject.one('align')(this.e, 0.5);
      return inject.one('cohere')(this.e, 1.0);
    };

    Unit.prototype.boid = function() {
      inject.one('separate')(this.e, 2.0);
      inject.one('align')(this.e, 0.5);
      return inject.one('cohere')(this.e, 1.0);
    };

    Unit.prototype.lineup = function() {
      inject.one('separate')(this.e, 0.6);
      return inject.one('line up')(this.e, 0.5);
    };

    Unit.prototype.square = function() {
      inject.one('separate')(this.e, 2);
      inject.one('align')(this.e, 0.4);
      inject.one('square group')(this.e, 0.5);
      return inject.one('cohere')(this.e, 0.1);
    };

    return Unit;

  })();
});
