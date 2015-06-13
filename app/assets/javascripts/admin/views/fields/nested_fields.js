var NestedFieldsView = Backbone.View.extend({

  initialize: function() {
    this.$button = $(".nested-fields-create").first();
    this.template = this.$button.data("template");
    this.templateID = this.$button.data("id");
  },

  addFieldgroup: function(event) {
    event.preventDefault();
    // We need to make up a new array index
    var time = new Date().getTime();
    var regexp = new RegExp(this.templateID, "g");
    // Duplicate the template into the form
    var elements = $(this.template.replace(regexp, time));
    // Initialize any Backbone Views by asking FormOrchestrator
    FormOrchestrator.initializeViewsOver(elements);
    this.$button.before(elements);
  },

  removeFieldgroup: function(event) {

    event.preventDefault();

    var $parentHeader = $(event.currentTarget).parents(".nested-fields-header").first();
    var $fieldgroup = $parentHeader.nextUntil(".nested-fields-header, .nested-fields-create");
    var $destroyInput = $fieldgroup.filter("input[name*='_destroy']").first()

    if (!!$destroyInput.length) {
      // The model is already persisted, set the destruction flag
      // and present the undo button/confirmation.
      $destroyInput.val("1");
      $fieldgroup.filter(":not(.nested-fields-undo)").slideUp(150);
      $fieldgroup.filter(".nested-fields-undo").first().slideDown(150);
    }
    else {
      // This model wasn't persisted, just discard the form fields.
      $fieldgroup.remove();
      $parentHeader.remove();
    }

  },

  restoreFieldgroup: function(event) {

    var $undoControl = $(event.currentTarget)
    var $fieldgroup = $undoControl.nextUntil(".nested-fields-header, .nested-fields-create");
    var $destroyInput = $fieldgroup.filter("input[name*='_destroy']").first();

    $destroyInput.val("0");
    $fieldgroup.filter(":not(.nested-fields-header, .nested-fields-undo)").show();
    $undoControl.hide();

  },

  events: {
    "click .nested-fields-create": "addFieldgroup",
    "click .nested-fields-group-remove": "removeFieldgroup",
    "click .nested-fields-undo": "restoreFieldgroup",
  }

});

FormOrchestrator.register(".nested-fields", "NestedFieldsView");
