// Generated by CoffeeScript 1.7.1
(function() {
  define([], function() {
    return function(string, payload) {
      if (payload == null) {
        return string;
      }
      return string.replace(/{([^{}]+)}/g, function(original, key) {
        if (payload[key] == null) {
          return original;
        }
        return payload[key];
      });
    };
  });

}).call(this);
