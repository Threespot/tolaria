var SearchableSelectViewController = Backbone.View.extend({

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
    placeholder_text_multiple: "Press to search",
    placeholder_text_single:	"Select one",
    search_contains: true,
    single_backstroke_delete: true,
    display_disabled_options: true,
    display_selected_options: true,
    include_group_label_in_selected: false,
    width: "100%"
  },

  initialize: function() {

    var self = this;

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

});

$(".searchable-select").each(function() {
  new SearchableSelectViewController({el:this});
});
