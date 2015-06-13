var SlugFieldView = Backbone.View.extend({

  initialize: function() {
    this.$previewFragment = this.$(".slug-field-preview-fragment");
    this.$input = this.$("input");
    this.refreshPreview();
  },

  refreshPreview: function() {

    var val = $.trim(this.$input.val())

    if (!!val) {
      this.$previewFragment.html(this.parameterize(val))
    }
    else {
      this.$previewFragment.html("*")
    }

  },

  seperatorRegex: /(?:[^a-z0-9\-_]+|-{2,}|\s{1,})/gi,
  badSeperatorRegex: /^-|-$/,

  parameterize: function(string) {
    return string.replace(this.seperatorRegex, "-")
      .replace(this.badSeperatorRegex, "")
      .toLowerCase();
  },

  events: {
    "keyup": "refreshPreview",
    "change input": "refreshPreview"
  }

});

FormOrchestrator.register(".slug-field", "SlugFieldView");
