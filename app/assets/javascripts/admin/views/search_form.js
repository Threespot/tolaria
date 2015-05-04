var SearchFormViewController = Backbone.View.extend({

  el: "body",

  initialize: function() {
    this.$form = this.$(".search-form");
  },

  toggleForm: function() {
    this.$form.fadeToggle(100);
  },

  events: {
    "click .search-form-toggle": "toggleForm"
  }

});

new SearchFormViewController;
