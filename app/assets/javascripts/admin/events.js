var Events = _.extend({

  initialize: function() {
    var self = this;
    var $window = $(window);
    var $body = $("body");

    // Save current width to compare on resize (filter out vertical resize)
    this.oldWidth = this.getWinWidth();

    // Add a listener to the window.resize event, pass this as the scope
    $window.resize( $.proxy( _.debounce( this.resizeDebounce, 200 ), this ) );

    // Add listener to the body
    // $body.on("click", function( evt ) {
    //   self.trigger("bodyClick", evt);
    // });

    return this;
  },

  resizeDebounce: function() {
    // Only trigger if width changed, not just the height
    if ( this.getWinWidth() !== this.oldWidth ) {
      // Emit resize event
      this.trigger("resize");

      // Update window width
      this.oldWidth = this.getWinWidth();
    }
  },

  getWinWidth: function() {
    return $(window).width();
  }

}, Backbone.Events );

Events.initialize();
