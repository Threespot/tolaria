var ResourceFormViewController = Backbone.View.extend({

  el: ".resource-form",

  initialize: function() {
    this.focusFirstInput();
  },

  focusFirstInput: function() {
    this.$("input:visible, select:visible, textarea:visible").first().focus();
  },

  events: {
  }

});

new ResourceFormViewController;
