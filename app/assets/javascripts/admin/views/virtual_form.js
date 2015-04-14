var VirualFormViewController = Backbone.View.extend({

  el: "body",

  csrfToken: $("meta[name=csrf-token]").attr("content"),
  csrfParam: $("meta[name=csrf-param]").attr("content"),

  submitVirtualForm: function(event) {

    event.preventDefault();
    var $link = $(event.currentTarget);

    var confirm = $link.attr("data-confirm");
    var method = $link.attr("data-method");

    // Check for a confirmation attribute and if so, prompt the user
    if (!!confirm) {
      if (!window.confirm(confirm)) {
        return false;
      }
    }

    var href = $link.attr("href");
    var target = $link.attr("target");

    var $form = $('<form method="post" action="' + href + '"></form>');
    var $metadataInputs = '<input name="_method" value="' + method + '" type="hidden" />';

    if (!!this.csrfToken && !!this.csrfParam) {
      $metadataInputs += '<input name="' + this.csrfParam + '" value="' + this.csrfToken + '" type="hidden" />';
    }

    if (!!target) {
      form.attr("target", target);
    }

    $form.hide().append($metadataInputs).appendTo(this.$el);
    $form.submit();

  },

  events: {
    "click a[data-method=delete]": "submitVirtualForm",
    "click a[data-method=post]": "submitVirtualForm",
    "click a[data-method=put]": "submitVirtualForm"
  }

});

new VirualFormViewController;
