var SessionView = Backbone.View.extend({

  el: "#session-form",
  readyToSubmit: false,

  initialize: function () {
    this.$submitButton = this.$("#session-form-submit");
    this.$emailInput = this.$("#session-form-email");
    this.$passcodeInput = this.$("#session-form-passcode");
    this.$spinner = this.$("#session-spinner");
    this.$feedbackMessage = this.$("#session-form-feedback");
    this.$resendButton = this.$("#session-form-resend");
    this.$rememberGroup = this.$("#session-form-remember-group");
  },

  requestAuthenticationCode: function(event) {

    var self = this;

    self.$passcodeInput.fadeOut(300);
    self.$submitButton.fadeOut(300);
    self.$resendButton.fadeOut(300);
    self.$feedbackMessage.fadeOut(300);
    self.$emailInput.fadeOut(300);
    self.$rememberGroup.fadeOut(300);

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
          xhr.setRequestHeader("X-CSRF-Token", RailsMeta.csrfToken);
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
          },
          500: function(xhr, status, error) {
            self.presentErrorMessage("An unexpected server error occurred. Developers have been notified. Please try again\xA0later.")
          }
        },

        timeout: 5000,
        error: function(xhr, status, error) {
          self.presentErrorMessage("Could not connect to the server. Check your network connection and try\xA0again.")
        }

      });

    }, 300);

  },

  presentErrorMessage: function(message) {
    var self = this;
    self.readyToSubmit = false;
    self.$spinner.fadeOut(400, function() {
      self.$feedbackMessage.html(message).fadeIn(300);
      self.$emailInput.fadeIn(300);
      self.$submitButton.html("Request a passcode").fadeIn(300);
    });
  },

  presentPasscodeInput: function() {
    var self = this;
    self.readyToSubmit = true;
    self.$spinner.fadeOut(400, function() {
      self.$passcodeInput.fadeIn(300).val("").focus();
      self.$feedbackMessage.html("A passcode was just emailed to you.<br> Enter it here to sign in.").fadeIn(300);
      self.$submitButton.html("Sign In").fadeIn(300);
      self.$rememberGroup.fadeIn(300);
      self.$resendButton.fadeIn(300);
    });
  },

  handleSubmit: function(event) {
    if (!this.readyToSubmit) {
      event.preventDefault();
      event.stopPropagation();
      this.requestAuthenticationCode();
    }
  },

  events: {
    "submit": "handleSubmit",
    "click button": "handleSubmit",
    "click #session-form-resend": "requestAuthenticationCode"
  }

});

var SessionView = new SessionView;
