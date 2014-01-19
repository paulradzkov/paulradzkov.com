$(document).ready(function(){
  	// Your code here...

  	var menuTrigger = $(".js-menu-trigger");
    var menuOverlay = $(".js-menu-overlay")
    var menuPopupTrigger = $(".js-popup-trigger")
  	var menuPopup = $(".js-menu-popup")

  	menuTrigger.click(function(){
  		$("body").toggleClass("site-nav-is-opened");
  	});
  	
  	menuOverlay.click(function(){
  		$("body").toggleClass("site-nav-is-opened");
  	});

    menuPopupTrigger.click(function(){
      menuPopup.toggleClass("popup-is-opened");
    });

});