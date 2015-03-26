var SessionViewController = Backbone.View.extend({

  el: "#session-form",

  initialize: function () {
    this.$requestButton = this.$("#session-form-request");
    this.$submitButton = this.$("#session-form-submit");
    this.$emailInput = this.$("#session-form-email");
    this.$passcodeInput = this.$("#session-form-passcode");
    this.$spinner = this.$("#session-spinner");
    this.$feedbackMessage = this.$("#session-form-feedback");
    this.$resendButton = this.$("#session-form-resend");
  },

  requestAuthenticationCode: function(event) {

    var self = this;
    event.preventDefault();
    event.stopPropagation();

    self.$passcodeInput.fadeOut(300);
    self.$submitButton.fadeOut(300);
    self.$resendButton.fadeOut(300);
    self.$feedbackMessage.fadeOut(300);
    self.$requestButton.fadeOut(300);
    self.$emailInput.fadeOut(300);

    window.setTimeout(function() {

      self.$spinner.fadeIn(400);

      $.ajax({

        type: "POST",
        url: "/admin/signin/code",
        data: {
          "administrator": {
            "email": self.$emailInput.val()
          }
        },

        beforeSend: function(xhr) {
          xhr.setRequestHeader(
            "X-CSRF-Token", $("meta[name='csrf-token']").attr("content")
          );
        },

        statusCode: {
          204: function(data, xstatus, xhr) {
            self.presentPasscodeInput();
          },
          404: function(xhr, status, error) {
            self.presentErrorMessage(xhr.responseJSON.error)
          },
          423: function(xhr, status, error) {
            self.presentErrorMessage(xhr.responseJSON.error)
          }
        }

      });

    }, 300);

  },

  presentErrorMessage: function(message) {
    var self = this;
    self.$spinner.fadeOut(400, function() {
      self.$feedbackMessage.html(message).fadeIn(300);
      self.$emailInput.fadeIn(300);
      self.$requestButton.fadeIn(300);
    });
  },

  presentPasscodeInput: function() {
    var self = this;
    self.$spinner.fadeOut(400, function() {
      self.$passcodeInput.fadeIn(300).focus();
      self.$feedbackMessage.html("A passcode was just emailed to you.<br> Enter it here to sign in.").fadeIn(300);
      self.$submitButton.fadeIn(300);
      self.$resendButton.fadeIn(300);
    });
  },

  events: {
    "click #session-form-request": "requestAuthenticationCode",
    "click #session-form-resend": "requestAuthenticationCode"
  }

});

var SessionViewController = new SessionViewController;
