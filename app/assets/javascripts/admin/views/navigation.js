var NavigationViewController = Backbone.View.extend({

  el: "body",

  initialize: function() {
    this.$navigation = this.$(".navigation");
  },

  toggleNavigation: function(event) {
    event.preventDefault();
    this.$navigation.toggleClass("-open");
  },

  events: {
    "click .header-menu-trigger": "toggleNavigation"
  }

});

new NavigationViewController;
