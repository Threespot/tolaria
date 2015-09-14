var HasManyView = Backbone.View.extend({

  initialize: function() {
    this.$button = $(".has-many-create", this.el).first();
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

    var $parentHeader = $(event.currentTarget).parents(".has-many-header").first();
    var $fieldgroup = $parentHeader.nextUntil(".has-many-header, .has-many-create");
    var $destroyInput = $fieldgroup.filter("input[name*='_destroy']").first()

    if (!!$destroyInput.length) {
      // The model is already persisted, set the destruction flag
      // and present the undo button/confirmation.
      $destroyInput.val("1");
      $fieldgroup.filter(":not(.has-many-undo)").slideUp(150);
      $fieldgroup.filter(".has-many-undo").first().slideDown(150);
    }
    else {
      // This model wasn't persisted, just discard the form fields.
      $fieldgroup.remove();
      $parentHeader.remove();
    }

  },

  restoreFieldgroup: function(event) {

    var $undoControl = $(event.currentTarget)
    var $fieldgroup = $undoControl.nextUntil(".has-many-header, .has-many-create");
    var $destroyInput = $fieldgroup.filter("input[name*='_destroy']").first();

    $destroyInput.val("0");
    $fieldgroup.filter(":not(.has-many-header, .has-many-undo)").show();
    $undoControl.hide();

  },

  events: {
    "click .has-many-create": "addFieldgroup",
    "click .has-many-group-remove": "removeFieldgroup",
    "click .has-many-undo": "restoreFieldgroup",
  }

});

FormOrchestrator.register(".has-many", "HasManyView");
