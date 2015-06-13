var SwatchFieldView = Backbone.View.extend({

  initialize: function() {
    this.$swatch = this.$(".swatch-field-swatch");
    this.$input = this.$("input");
    this.refreshPreview();
  },

  colorRegex: /^(?:[0-9a-f]{3})(?:[0-9a-f]{3})?$/i,

  parseColor: function(color) {
    color = color.replace("#","");
    if (!!this.colorRegex.exec(color)) {
      return color.toUpperCase();
    }
    else {
      return false;
    }
  },

  refreshPreview: function() {
    var parsedColor = this.parseColor($.trim(this.$input.val()));
    if (!!parsedColor) {
      this.$swatch.attr("style", "background:#" + parsedColor + " !important");
      this.$swatch.addClass("-active");
    }
    else {
      this.$swatch.attr("style", "");
      this.$swatch.removeClass("-active");
    }
  },

  validateSelf: function() {
    var inputValue = $.trim(this.$input.val());
    var parsedColor = this.parseColor(inputValue);
    if (!parsedColor && inputValue !== "") {
      this.$el.addClass("field_with_errors");
    }
  },

  clearError: function() {
    this.$el.removeClass("field_with_errors");
  },

  events: {
    "keyup": "refreshPreview",
    "change input": "refreshPreview",
    "change input": "validateSelf",
    "blur input": "validateSelf",
    "focus input": "clearError"
  }

});

FormOrchestrator.register(".swatch-field", "SwatchFieldView");
