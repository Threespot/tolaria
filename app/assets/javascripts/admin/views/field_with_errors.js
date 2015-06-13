var FieldWithErrorsView = Backbone.View.extend({

  implode: function() {
    this.$el.removeClass("field_with_errors");
    this.unbind();
  },

  events: {
    "input focus": "implode",
    "select focus": "implode",
    "textarea focus": "implode",
    "click": "implode"
  }

});

$(".field_with_errors").each(function() {
  new FieldWithErrorsView({el:this});
});
