$(document).ready(function(){
	// init Isotope
	var $container = $('.js-isotope').isotope({
		"itemSelector": ".item",
		"layoutMode": "vertical" 
	});


	// filter items on button click
	$('#filters').on( 'click', '.btn', function( event ) {
		//event.preventDefault();
		var filterValue = $(this).attr('data-filter');
		$container.isotope({ filter: filterValue });
	});

	$('[name="view-options"]').change( function() {
		$container.isotope('layout');
	});

});