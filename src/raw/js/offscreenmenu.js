$(document).ready(function(){

  	var menuTrigger = $(".js-menu-trigger");
    var menuOverlay = $(".js-menu-overlay")

  	menuTrigger.click(function(){
  		$("body").toggleClass("site-nav-is-opened");
  	});
  	
  	menuOverlay.click(function(){
  		$("body").toggleClass("site-nav-is-opened");
  	});

});