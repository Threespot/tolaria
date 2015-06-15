var SearchableSelectView = Backbone.View.extend({

  // See http://harvesthq.github.io/chosen/options.html
  // for help with these options
  chosenOptions: {
    allow_single_deselect: false,
    disable_search: false,
    disable_search_threshold: 5,
    enable_split_word_search: true,
    inherit_select_classes: true,
    max_selected_options: Infinity,
    no_results_text: "Nothing matched",
    placeholder_text_multiple: "Select one or many",
    placeholder_text_single:	"Select one",
    search_contains: true,
    single_backstroke_delete: true,
    display_disabled_options: true,
    display_selected_options: true,
    include_group_label_in_selected: false,
    width: "100%"
  },

  // This function is stolen from Chosen.js because it does
  // not expose any kind of API for communicating that it will not run
  chosenSupported: function() {
    if (window.navigator.appName === "Microsoft Internet Explorer") {
      return document.documentMode >= 8;
    }
    if (/iP(od|hone)/i.test(window.navigator.userAgent)) {
      return false;
    }
    if (/Android/i.test(window.navigator.userAgent)) {
      if (/Mobile/i.test(window.navigator.userAgent)) {
        return false;
      }
    }
    return true;
  },

  initialize: function() {

    var self = this;

    if (self.chosenSupported()) {

      self.$select = self.$("select");
      var placeholderValue = self.$select.attr("placeholder");

      if (!!placeholderValue) {
        self.chosenOptions.placeholder_text_multiple = placeholderValue;
        self.chosenOptions.placeholder_text_single = placeholderValue;
      }

      self.$select.on("chosen:ready", function(event) {
        self.$el.attr("style","");
      });

      self.$select.chosen(self.chosenOptions);

    }
    else {
      // Chosen isn't going to run
      self.$el.attr("style","");
    }

  }

});

FormOrchestrator.register(".searchable-select", "SearchableSelectView");
