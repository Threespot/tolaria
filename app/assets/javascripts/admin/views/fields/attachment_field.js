var AttachmentFieldView = Backbone.View.extend({

  initialize: function() {
    this.$fileInput = this.$("input[type=file]");
    this.$label = this.$(".attachment-field-label");
    this.$icon = this.$(".icon");
    this.$preview = this.$(".attachment-field-preview");
  },

  activateFileInput: function(event) {
    event.preventDefault();
    this.$fileInput.focus().click();
  },

  refreshLabel: function() {
    if (!!this.$fileInput.val()) {
      this.$label.html("Ready to upload");
      this.$preview.hide();
      this.$icon.show().removeClass("icon-file-text-o icon-paperclip").addClass("icon-check-circle-o");
      this.$el.addClass("-ready");
    }
  },

  events: {
    "click button": "activateFileInput",
    "change input": "refreshLabel"
  }

});

FormOrchestrator.register(".attachment-field", "AttachmentFieldView");

