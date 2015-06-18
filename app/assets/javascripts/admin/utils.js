var utils = {

  // Measure height of element(s) by creating a hidden clone, then save the height to 'data-height' attribute
  // Used for accordion functionality in mobile nav
  storeHeight: function( $el, callback ) {
    if ( $el.length ) {
      for ( var i=0, len=$el.length; i<len; i++ ) {

        // Convert jQuery object to JS node if applicable
        // var el = ( $el[i] instanceof window.$ ? $el[i][0] : $el[i] );

        // var el = $el[i]
        var el = ( typeof window.$ !== "undefined" && $el[i] instanceof window.$ ? $el[i][0] : $el[i] );

        // Save reference to parent node
        var parentEl = el.parentNode;

        // Get width of oringial element
        var nodeWidth = Math.round( parseFloat( parentEl.offsetWidth ) );

        // Create clone of node
        var clone = el.cloneNode( true );// 'true' includes child nodes

        // Add inline styles to disable transitions and hide
        clone.style.cssText = "max-height: none; position: absolute; right: 100%; visibility: hidden; width: " + nodeWidth + 'px; -webkit-transition: none; -moz-transition: none; transition: none';

        // Append clone to document
        var newEl = parentEl.insertBefore( clone, el );

        // Calculate height
        var newHeight = Math.round( parseFloat( newEl.offsetHeight ) );
        // console.log( 'new height: ' + newHeight );

        // Remove cloned node
        parentEl.removeChild( newEl );

        // Set height as data attribute
        el.setAttribute("data-height", newHeight);

        // Determine if element is expanded by checking for inline max-height > 0
        var isExpanded = parseInt( el.style.maxHeight.replace( 'px', '' ), 10 ) > 0;
        // console.log( isExpanded ? 'expanded' : 'collapsed' );

        // Update inline max-height for expanded items
        if ( isExpanded ) {
          el.style.maxHeight = newHeight + "px";
        }
      }
    }

    // Run callback if present
    if ( typeof callback == "function" ) {
      callback( $el );
    }
  },
};
