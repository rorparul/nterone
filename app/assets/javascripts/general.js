$(function() {
  $('#menu-toggle').on('click', function() {
    $('.sidebar-content').fadeToggle();
  });

  $(document).on('mouseenter mouseleave', '.platform', function() {
    $(this).find('.actions-overlay').toggle();
  });

  $('.course').on('click', function() {
    sessionStorage.removeItem('category');
    sessionStorage.removeItem('subCategory');
  });

  $('.selectpicker').selectpicker();

  $(document).on('click', '.topic', function() {
    $('.topic').removeClass('active-topic');
    $(this).addClass('active-topic');
  });

  $('#myModal').on('show.bs.modal', function(e) {
    Bootsy.init();
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
});
