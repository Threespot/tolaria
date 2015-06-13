var FormOrchestrator = {

  // Filled with objects that map selectors to Backbone Views that
  // manage them, such as: ".timestamp-field" → "TimestampView"
  selectorMappings: [],

  // Register a selector (el) and the BackboneView that should be
  // created to manage each one
  register: function(selector, backboneViewName) {
    this.selectorMappings.push({
      selector: selector,
      backboneViewName: backboneViewName
    });
  },

  // Build each of the registered Backbone Views that are inside
  // the given rootSelector (either a CSS selector or a jQuery collection)
  initializeViewsOver: function(rootSelector) {

    this.selectorMappings.forEach(function(mapEntry) {

      // Passed a string selector, find descendants to initialize
      if (typeof rootSelector === "string") {
        $(rootSelector).find(mapEntry.selector).each(function() {
          new window[mapEntry.backboneViewName]({el:this});
        });
      }

      // Passed a jQuery collection, filter it to find elements to initialize
      if (typeof rootSelector === "object") {
        $(rootSelector).filter(mapEntry.selector).each(function() {
          new window[mapEntry.backboneViewName]({el:this});
        });
      }

    });

  }

};

