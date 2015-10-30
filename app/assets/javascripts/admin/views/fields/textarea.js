var TextareaView = Backbone.View.extend({

  initialize: function() {
    autosize(this.$el);
  },

});

FormOrchestrator.register("textarea:not(.markdown-composer-textarea, .disable-autosize)", "TextareaView");
