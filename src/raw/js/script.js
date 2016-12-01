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

    // smooth scrolling
    $('a[href*="#"]:not([href="#"])').click(function() {
        if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
            var target = $(this.hash);
            target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
            if (target.length) {
                $('html, body').animate({
                    scrollTop: target.offset().top
                }, 1000);
                return false;
            }
        }
    });

	// expired message
	$('.expired-read').on('click', function(event) {
		var target = $(this).data('target');
		$(target).hide();
	});

	//bootstrap tooltip
	$('[data-toggle="tooltip"]').tooltip();

	//toggle-view blogroll
	$('[name="view-options"]').change( function() {
		$('.blogroll').toggleClass('detailed-view short-view');
	});

	//toggle-chars table
	$('[name="chars-view"]').change( function() {
		$('.chars').toggleClass('layout-flow');
	});
});

//fallback for svg if not supported
if (!Modernizr.svg) {
	$('img[src$=".svg"]').each(function()
	{
		$(this).attr('src', $(this).attr('src').replace('.svg', '.png'));
	});
}
