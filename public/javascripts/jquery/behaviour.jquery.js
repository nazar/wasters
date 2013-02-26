(function($) {
    
Hover = $.klass({
  initialize: function(hoverClass) {
    this.hoverClass = hoverClass;
  },
  onmouseover: function() {
    this.element.addClass(this.hoverClass);
  },
  onmouseout: function() {
    this.element.removeClass(this.hoverClass);
  }
});

Popup = $.klass({
  initialize: function(options) {
    this.options = Object.extend({
        trigger: 'hoverIntent',
        ajaxPath: ['this.href'],
        ajaxLoading: '<div id="popup_item_info"><table><tr align="center"><td><img src="/images/spinner.gif" width="16px" height="16px"/></div></td></tr></table>',
        fill: '#000',
        cssStyles: {
            fontFamily: 'Arial, "Helvetica Neue", Helvetica, sans-serif',
            fontSize: '11px',
            width: 'auto',
            color: 'white'
        },
        width: '350px',
        strokeWidth: 1,
        strokeStyle: 'black',
        hoverIntentOpts:  { interval: 300, timeout: 500 },
        positions: ['right'],
        closeWhenOthersOpen: true},
    options || {
    });
    this.element.bt(this.options);
  },
  onclick: function(){
    this.element.btOff();
  }
});


})(jQuery);
