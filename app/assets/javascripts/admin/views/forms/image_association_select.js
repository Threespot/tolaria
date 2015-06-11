var ImageAssociationSelectView = Backbone.View.extend({

  initialize: function() {
    this.$select = this.$el.find("select")
    this.$previewImage = this.$el.find(".image-association-select-image");
    this.hiddenClass = "-hidden";

    if (this.$select.val() > 0) {
      var src = this.$select.find(":selected").data("url");
      this.$previewImage.removeClass(this.hiddenClass).attr("src", src);
    }
  },

  events: {
    "change select": "previewImage"
  },

  previewImage: function() {
    var src = this.$select.find(":selected").data("url");

    if (typeof src === "undefined"){
      this.$previewImage.addClass(this.hiddenClass);
    } else {
      this.$previewImage.attr("src", src);
      this.$previewImage.removeClass(this.hiddenClass);
    }
  }

});


var ImageAssociationSelect = new ImageAssociationSelectView({
  el: $(".image-association-select")
});
