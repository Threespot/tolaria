moment.locale("en");

var TimestampFieldView = Backbone.View.extend({

  momentFormats: [
    "YYYY-MM-DD hh:mm A",
    "YYYY-MM-DD hh:mm a"
  ],

  initialize: function() {

    this.$year = this.$("select[name*='(1i)']");
    this.$month = this.$("select[name*='(2i)']");
    this.$date = this.$("select[name*='(3i)']");
    this.$hour = this.$("select[name*='(4i)']");
    this.$minute = this.$("select[name*='(5i)']");

    this.$input = this.$("input[type=text]");
    this.recoveryValue = this.$input.data("recovery-value");

  },

  attemptRecovery: function() {
    this.$el.removeClass("field_with_errors");
    if (!$.trim(this.$input.val())) {
      this.$input.val(this.recoveryValue);
    }
  },

  // Rails expects hours and minutes in two-digit format
  padSingleDigits: function(numeric) {
    if (numeric < 10) {
      return "0" + numeric.toString();
    }
    else {
      return numeric;
    }
  },

  parseTime: function() {

    var parsedMoment = moment(this.$input.val(), this.momentFormats);

    if (parsedMoment.isValid()) {
      this.$year.val(parsedMoment.year());
      this.$month.val(parsedMoment.month() + 1); // Moment.js months are 0 indexed
      this.$date.val(parsedMoment.date());
      this.$hour.val(this.padSingleDigits(parsedMoment.hour()));
      this.$minute.val(this.padSingleDigits(parsedMoment.minute()));
    }
    else {
      this.$year.val("");
      this.$month.val("");
      this.$date.val("");
      this.$hour.val("");
      this.$minute.val("");
      this.$el.addClass("field_with_errors");
    }

    console.log("Timestamp field changed:", [
      this.$year.val(),
      this.$month.val(),
      this.$date.val(),
      this.$hour.val(),
      this.$minute.val(),
      parsedMoment.format("dddd, MMMM Do YYYY, h:mm:ss a"),
      this.$input.val()
    ]);

  },

  events: {
    "change input": "parseTime",
    "blur input": "parseTime",
    "focus input": "attemptRecovery",
  }

});

FormOrchestrator.register(".timestamp-field", "TimestampFieldView");
