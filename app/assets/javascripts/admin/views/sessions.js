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

    $.ajax({
      type: "POST",
      url: "/admin/signin/code?email=" + encodeURIComponent(self.$emailInput.val()),
      success: function(result) {
        if (result.status === "success") {
          window.setTimeout(function() {
            self.presentPasscodeInput();
          }, 2000);
        } else {
          // auth was not sucessful due to the account being locked or no account with the email submitted found
          // responses are in result.message
          // TODO: deal w/ these responses accordingly
          console.log(result.message);
        }
      }
    });

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
