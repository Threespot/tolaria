//= require admin/config
//= require_self

define(["custom"], function() {

  "use strict";

  function applicationBootstrap() {

    var modules = [];

    // Require additional modules here by detecting
    // page elements or browser features

    // if(!!document.getElementById("subnav")) {
    //   modules.push("modules/subnav");
    // }

    require(modules, function() {
      for (var i = 0; i < arguments.length; i++) {
        arguments[i](); // Invoke the module
      }
    });

  }

  // Run on DOMReady and on Turbolinks page change
  applicationBootstrap();
  window.addEventListener("page:change", applicationBootstrap, false);

});
