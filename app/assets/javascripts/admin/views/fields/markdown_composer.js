var MarkdownComposerView = Backbone.View.extend({

  fullscreen: false, // Currently expanded to fullscreen
  livePreview: false, // The preview block is currently updating on keyup

  initialize: function() {
    this.$textarea = this.$("textarea");
    this.$preview = this.$(".markdown-composer-preview");
    this.$fullscreenButtonLabel = this.$(".-fullscreen-toggle span");
    this.$fullscreenButtonIcon = this.$(".-fullscreen-toggle .icon");
  },

  // Brighten and highlight the composer UI
  brightenSelf: function() {
    this.$el.addClass("-focused");
  },

  // Dim the composer. Cannot be dimmed at fullscreen.
  dimSelf: function() {
    this.$el.removeClass("-focused");
  },

  toggleFullscreen: function(event) {
    event.preventDefault();
    if (!this.fullscreen) {
      this.fullscreen = true;
      this.livePreview = true;
      this.updatePreview();
      this.$preview.show();
      this.$el.addClass("-fullscreen");
      $("body").addClass("-modal-open");
      this.$fullscreenButtonLabel.html("Close Fullscreen");
      this.$fullscreenButtonIcon.removeClass("icon-arrows-alt").addClass("icon-compress");
      this.$textarea.focus();
    }
    else {
      this.fullscreen = false;
      this.livePreview = false;
      this.$preview.hide();
      this.$el.removeClass("-fullscreen");
      $("body").removeClass("-modal-open");
      this.$fullscreenButtonLabel.html("Fullscreen");
      this.$fullscreenButtonIcon.removeClass("icon-compress").addClass("icon-arrows-alt");
      this.$textarea.focus();
    }
  },

  // Update the preview on keyup if it is currently live-updating
  keyupCallback: function() {
    if (this.livePreview) {
      this.updatePreview();
    }
  },

  updatePreview: function() {
    var trimmedDocument = $.trim(this.$textarea.val());
    if (!trimmedDocument) {
      this.presentErrorMessage("A preview of what you type will be shown here.");
      return true;
    }
    this.renderMarkdown(trimmedDocument);
    return true;
  },

  // Send the Markdown to the server for converting into HTML

  renderMarkdown: function(markdownDocument) {

    var self = this;

    $.ajax({

      type: "POST",
      url: "/admin/api/markdown",
      data: markdownDocument,
      contentType: "text/plain",

      beforeSend: function(xhr) {
        xhr.setRequestHeader("X-CSRF-Token", RailsMeta.csrfToken);
      },

      dataType: "html",
      processData: false,

      statusCode: {
        200: function(data, xstatus, xhr) {
          self.$preview.html(data);
        },
        404: function(xhr, status, error) {
          self.presentErrorMessage("The server refused to send you a preview. Please sign in and out of the admin panel and try again.");
        },
        500: function(xhr, status, error) {
          self.presentErrorMessage("An unexpected server error occurred. Developers have been notified. Please try again\xA0later.");
        }
      },

      timeout: 3000,
      error: function(xhr, status, error) {
        self.presentErrorMessage("Could not connect to the server. Please check your network connection and try\xA0again.");
      }

    });

  },

  // Act on a formatting button by either inserting the example
  // syntax or wrapping the text selection in the chosen button's syntax

  formatButton: function(event, mode) {

    event.preventDefault();

    // Save current scroll position of textarea so we can reset it after we update the text
    var scrollPos = this.$textarea.scrollTop();

    var selectedText = this.$textarea.selection("get");
    var buttonOps = ComposerButtons[mode];

    if (selectedText.length > 0) {
      // Wrap each selected line in the syntax
      var replacementText = [];
      var lines = selectedText.match(/^.*((\r\n|\n|\r)|$)/gm);

      $.each(lines, function(index, value){
        // strip new lines
        value = value.replace(/(\r\n|\n|\r)/, '');

        // Check if selected formatting includes a prefix and/or suffix
        var hasBefore = buttonOps.before.length > 0;
        var hasAfter = buttonOps.after.length > 0;
        var hasBoth = hasBefore && hasAfter;

        // Get prefix and suffix from selected text
        var before = value.substr(0, buttonOps.before.length);
        var after = value.substr(-buttonOps.after.length);

        // Remove existing prefix and suffix if already applied to selected text (e.g. bold and italics)
        if ( hasBoth && before === buttonOps.before && after === buttonOps.after ) {
          value = value.substr(buttonOps.before.length);
          value = value.substr(0, value.length - buttonOps.after.length);
          replacementText.push(value);
        }
        // Remove prefix styling if already applied to selected text (e.g. headings, lists, and quotes)
        else if ( hasBefore && before === buttonOps.before ) {
          value = value.substr(buttonOps.before.length);
          replacementText.push(value);
        }
        // Add styling
        else {
          replacementText.push(buttonOps.before + value + buttonOps.after)
        }
      });

      this.$textarea.selection("replace", {text: replacementText.join("\n")});
    }
    else {
      // Insert some example text with the syntax
      this.$textarea.selection("replace", {
        text: buttonOps.vanilla,
        caret: "keep"
      });
    }

    this.updatePreview();

    // Reset scroll position
    this.$textarea.scrollTop(scrollPos);
  },

  // Show an error message in the preview with dimmed text
  presentErrorMessage: function(message) {
    this.$preview.html("<p class='dim'>" + message + "</p>");
  },

  events: {

    "keyup": "keyupCallback",
    "focus textarea": "brightenSelf",
    "blur textarea": "dimSelf",

    "click .-fullscreen-toggle": "toggleFullscreen",

    // Formatting buttons
    "click .-header": function(event) {this.formatButton(event, "header")},
    "click .-em": function(event) {this.formatButton(event, "em")},
    "click .-strong": function(event) {this.formatButton(event, "strong")},
    "click .-link": function(event) {this.formatButton(event, "link")},
    "click .-ordered-list": function(event) {this.formatButton(event, "ordered-list")},
    "click .-unordered-list": function(event) {this.formatButton(event, "unordered-list")},
    "click .-blockquote": function(event) {this.formatButton(event, "blockquote")}

  }

});

FormOrchestrator.register(".markdown-composer", "MarkdownComposerView");
