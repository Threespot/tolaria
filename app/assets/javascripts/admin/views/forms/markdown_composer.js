var MarkdownComposerViewController = Backbone.View.extend({

  fullscreen: false,
  previewLive: false,

  initialize: function() {
    this.$textarea = this.$("textarea");
    this.$preview = this.$(".markdown-composer-preview");
    this.$previewButtonLabel = this.$(".-preview-toggle span");
    this.$previewButtonIcon = this.$(".-preview-toggle .icon");
    this.$fullscreenButtonLabel = this.$(".-fullscreen-toggle span");
    this.$fullscreenButtonIcon = this.$(".-fullscreen-toggle .icon");
  },

  brightenSelf: function() {
    this.$el.addClass("-focused");
  },

  dimSelf: function() {
    if (!this.fullscreen) {
      this.$el.removeClass("-focused");
    }
  },

  toggleFullscreen: function(event) {
    event.preventDefault();
    if (!this.fullscreen) {
      this.fullscreen = true;
      this.previewLive = true;
      this.updatePreview();
      this.$el.addClass("-fullscreen");
      $("body").addClass("-modal-open");
      this.brightenSelf();
      this.$fullscreenButtonLabel.html("Close Fullscreen");
      this.$fullscreenButtonIcon.removeClass("icon-arrows-alt").addClass("icon-compress");
      this.$textarea.focus();
    }
    else {
      this.fullscreen = false;
      this.previewLive = false;
      this.$el.removeClass("-fullscreen");
      $("body").removeClass("-modal-open");
      this.dimSelf();
      this.$fullscreenButtonLabel.html("Fullscreen");
      this.$fullscreenButtonIcon.removeClass("icon-compress").addClass("icon-arrows-alt");
    }
  },

  updatePreview: function() {

    if (!this.previewLive) { return false; }

    var trimmedDocument = $.trim(this.$textarea.val());

    if (!trimmedDocument) {
      this.presentErrorMessage("A preview of what you type will be shown here.");
      return true;
    }

    this.renderMarkdown(trimmedDocument);
    return true;

  },

  renderMarkdown: function(markdownDocument) {

    var self = this;

    $.ajax({

      type: "POST",
      url: "/admin/api/markdown",
      data: markdownDocument,
      traditional: true,
      contentType: "text/plain",

      beforeSend: function(xhr) {
        xhr.setRequestHeader(
          "X-CSRF-Token", $("meta[name='csrf-token']").attr("content")
        );
      },

      statusCode: {
        200: function(data, xstatus, xhr) {
          self.$preview.html(data);
        },
        404: function(xhr, status, error) {
          self.presentErrorMessage("The server refused to send you a preview. Please sign in and out of the admin panel and try again.");
        },
        500: function(xhr, status, error) {
          self.presentErrorMessage("An unexpected server error occurred. Developers have been notified. Please try again\xA0later.")
        }
      },

      timeout: 5000,
      error: function(xhr, status, error) {
        self.presentErrorMessage("Could not connect to the server. Please check your network connection and try\xA0again.");
      }

    });

  },

  // Act on a formatting button by either inserting the example
  // sytnax or wrapping the text selection in the chosen button's syntax
  formatButton: function(event, mode) {

    event.preventDefault();

    var selectedText = this.$textarea.selection("get");
    var buttonOps = ComposerButtons[mode];

    if (selectedText.length > 0) {
      // Wrap the selected text in the syntax
      this.$textarea.selection("insert", {
        mode: "before",
        text: buttonOps.before,
        caret: "keep"
      });
      this.$textarea.selection("insert", {
        mode: "after",
        text: buttonOps.after,
        caret: "keep"
      });
    }
    else {
      // Insert some example text with the syntax
      this.$textarea.selection("replace", {
        text: buttonOps.vanilla,
        caret: "keep"
      });
    }

  },

  // Show an error message in the preview with dimmed text
  presentErrorMessage: function(message) {
    this.$preview.html("<p class='dim'>" + message + "</p>");
  },

  events: {

    "keyup": "updatePreview",
    "focus textarea": "brightenSelf",
    "blur textarea": "dimSelf",

    "click .-fullscreen-toggle": "toggleFullscreen",

    // Formatting buttons
    "click .-header": function(event) {this.formatButton(event, "header")},
    "click .-em": function(event) {this.formatButton(event, "em")},
    "click .-strong": function(event) {this.formatButton(event, "strong")},
    "click .-image": function(event) {this.formatButton(event, "image")},
    "click .-link": function(event) {this.formatButton(event, "link")},
    "click .-ordered-list": function(event) {this.formatButton(event, "ordered-list")},
    "click .-unordered-list": function(event) {this.formatButton(event, "unordered-list")},
    "click .-blockquote": function(event) {this.formatButton(event, "blockquote")}

  }

});


$(".markdown-composer").each(function() {
  new MarkdownComposerViewController({el:this});
});
