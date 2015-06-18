var NavigationView = Backbone.View.extend({

  el: "body",

  initialize: function() {
    var self = this;

    this.$navigation = this.$(".navigation");
    this.isOpen = false;

    utils.storeHeight(this.$navigation);

    Events.on("resize", function() {
      utils.storeHeight( self.$navigation );

      if (Events.getWinWidth() >= 860) {
        self.collapse();
      }
    });
  },

  events: {
    "click .header-menu-trigger": "toggleNavigation"
  },

  toggleNavigation: function(evt) {
    evt.preventDefault();

    if (this.isOpen) {
      this.collapse();
    } else {
      this.expand();
    }
  },

  expand: function() {
    this.$navigation.css({
      "max-height": this.$navigation.attr("data-height") + "px"
    });
    this.isOpen = true;
  },

  // Collapse expandable
  collapse: function() {
    this.$navigation.css({
      "max-height": "0"
    });
    this.isOpen = false;
  }

});

new NavigationView;
