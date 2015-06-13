var FlashMessageView = Backbone.View.extend({

  dismissSelf: function() {
    this.$el.slideUp(200, function() {
      this.remove();
      delete this;
    });
  },

  events: {
    "click": "dismissSelf"
  }

});

$(".flash-message").each(function() {
  new FlashMessageView({el:this});
});
