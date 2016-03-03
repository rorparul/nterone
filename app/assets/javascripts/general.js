$(function() {
  $('.selectpicker').selectpicker();

  $('#menu-toggle').on('click', function() {
    $('.sidebar-content').fadeToggle();
  });

  $('.course').on('click', function() {
    sessionStorage.removeItem('category');
    sessionStorage.removeItem('subCategory');
  });

  $(document).on('click', '.topic', function() {
    $('.topic').removeClass('active-topic');
    $(this).addClass('active-topic');
  });

  $('#myModal').on('shown.bs.modal', function(e) {
    $('#query').focus();
  });

  $(document).on('change', '.sub-select', function() {
    $(this).closest('form').submit();
  });

  $('#accordion').on('show.bs.collapse', function () {
    $('#accordion .in').collapse('hide');
  });

  $('.btn-category').click(function() {
    $('.active-category').removeClass('active-category');
    $(this).addClass('active-category');
  });

  $('.btn-child-category').click(function() {
    $('.btn-child-category.active-category').removeClass('active-category');
    $(this).addClass('active-category');
  });

  $('.not-accordion').click(function() {
    $('#accordion .in').collapse('hide');
    $('#mobile-accordion .in').collapse('hide');
  });

  // $(document).on('scroll', function() {
	// 	var windowScroll = $(window).scrollTop();
	// 	var offerOffSet = $('.content').offset().top;
	// 	var difference = windowScroll - offerOffSet;
	// 	if(difference >= -10) {
	// 		$('.sidebar-v2').addClass("fixed");
	// 	} else {
	// 		$('.sidebar-v2').removeClass("fixed");
	// 	}
	// })
  
  $(".col-central").filter(function () {
    var html = $(this).html();
    var emailPattern = /[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/g;

    var matched_str = $(this).html().match(emailPattern);
    if (matched_str) {
      var text = $(this).html();
      $.each(matched_str, function (index, value) {
          text = text.replace(value,"<a href='mailto:"+value+"'>"+value+"</a>");
      });
      $(this).html(text);
      return $(this)
    }
  });
});

$(document).on('page:change', function() {
  Bootsy.init();
});
