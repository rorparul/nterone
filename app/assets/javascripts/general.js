$(function() {
  $('.selectpicker').selectpicker();

  $('#menu-toggle').on('click', function() {
    var $sidebarContent = $('.sidebar-content');
    $sidebarContent.fadeToggle();
  });

  $(document).on('click', '.topic', function() {
    $('.topic').removeClass('active-topic');
    $(this).addClass('active-topic');
  });

  $('#myModal').on('shown.bs.modal', function(e) {
    $('#query').focus();
  });

  $('#accordion').on('show.bs.collapse', function () {
    $('#accordion .in').collapse('hide');
  });

  $('.not-accordion').click(function() {
    $('#accordion .in').collapse('hide');
    $('#mobile-accordion .in').collapse('hide');
  });

  $(document).on('scroll', function() {
    if (!$('.content').offset()) return

		var windowScroll = $(window).scrollTop();
		var offerOffSet = $('.content').offset().top;
		var difference = windowScroll - offerOffSet;
		if(difference >= -30) {
			$('.sidebar-v2').addClass("fixed");
		} else {
			$('.sidebar-v2').removeClass("fixed");
		}
	});

  $('.wysihtml5').wysihtml5({
    toolbar: {
      'font-styles': true,
      'color': false,
      'emphasis': {
        'small': true
      },
      'blockquote': false,
      'lists': true,
      'html': true,
      'link': true,
      'image': false,
      'smallmodals': true
    }
  });
});
