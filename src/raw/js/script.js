/* Your scripts go here */
$(document).ready(function(){

	$("#sticker").sticky({topSpacing:0, wrapperClassName: "hold", className:"fixed"});

	//detect scrolling direction

	$(function(){
	    var lastScrollTop = 0, delta = 5;
	    $(window).scroll(function(event){
	       var st = $(this).scrollTop();
	       
	       if(Math.abs(lastScrollTop - st) <= delta)
	          return;
	       
	       if (st > lastScrollTop){
	           // downscroll code
	           $("#sticker-sticky-wrapper.fixed").removeClass("scrolltop").addClass("scrolldown");
	       } else {
	          // upscroll code
	          $("#sticker-sticky-wrapper.fixed").removeClass("scrolldown").addClass("scrolltop");
	       }
	       lastScrollTop = st;
	    });
	});
});

//fallback for svg if not supported
if (!Modernizr.svg) {
	$('img[src$=".svg"]').each(function()
	{
		$(this).attr('src', $(this).attr('src').replace('.svg', '.png'));
	});
}