// You can listenTo WindowModel to subscribe to a central
// singleton that emits debounced events on resize and scroll.
// You also have direct access to WindowModel.$window
// and WindowModel.$document for measuring things

var WindowModel = Backbone.Model.extend({

  $window: null,
  $document: null,

  initialize: function() {

    var self = this;
    self.$window = $(window);
    self.$document = $(document);

    var lazyResize = _.debounce(function() {
      self.trigger("resize");
    }, 100);

    var lazyScroll = _.debounce(function() {
      self.trigger("scroll");
    }, 50);

    self.$window.resize(lazyResize);
    self.$window.scroll(lazyScroll);

  }

});

// WindowModel is a singleton
WindowModel = new WindowModel;
