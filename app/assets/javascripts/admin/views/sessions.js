var SessionViewController = Backbone.View.extend({

  el: "#session-form",

  initialize: function () {
    this.$requestButton = this.$("#session-form-request");
    this.$submitButton = this.$("#session-form-submit");
    this.$emailInput = this.$("#session-form-email");
    this.$passcodeInput = this.$("#session-form-passcode");
    this.$spinner = this.$("#session-spinner");
    this.$helpMessage = this.$(".session-form-help");
  },

  requestAuthenticationCode: function(event) {

    var self = this;
    event.preventDefault();
    event.stopPropagation();

    self.$requestButton.fadeOut(200);
    self.$passcodeInput.hide();
    self.$helpMessage.hide();
    self.$submitButton.hide();
    self.$emailInput.fadeOut(200, function() {
      self.$spinner.fadeIn(400);
    });

    window.setTimeout(function() {
      self.presentPasscodeInput();
    }, 2000);

  },

  presentPasscodeInput: function() {
    var self = this;
    self.$spinner.fadeOut(400, function() {
      self.$passcodeInput.fadeIn(200).focus();
      self.$helpMessage.fadeIn(200);
      self.$submitButton.fadeIn(200);
    });
  },

  events: {
    "click #session-form-request": "requestAuthenticationCode",
    "click #session-form-resend": "requestAuthenticationCode"
  }

});

var SessionViewController = new SessionViewController;
