$(function() {
  prepareInputs();

  $('.selectpicker').selectpicker();

  if ($('.alert').length) {
    var alertQuantity  = $('.alert').length
    var alertHeight    = $('.alert').outerHeight()
    var valueIncrement = alertQuantity * alertHeight

    $('main').css('padding-top', '+=' + valueIncrement)
  }

  $('.alert').on('close.bs.alert', function () {
    var valueDecrement = $(this).outerHeight()

    $('main').css('padding-top', '-=' + valueDecrement)
  })

  $('#menu-toggle').on('click', function() {
    var $sidebarContent = $('.sidebar-content');
    $sidebarContent.fadeToggle();
  });

  $('#myModal').on('shown.bs.modal', function(e) {
    $('#myModal #query').focus();
    $('#myModal input[autofocus]').focus();
    prepareInputs();
  });

  $('#accordion').on('show.bs.collapse', function () {
    $('#accordion .in').collapse('hide');
  });

  $('.not-accordion').click(function() {
    $('#accordion .in').collapse('hide');
    $('#mobile-accordion .in').collapse('hide');
  });
});

function prepareInputs() {
  $("input[data-linked]").each(function(i) {
    var $this = $(this);
    var linked_element = $($this.data("linked"));
    linked_element.val("");
    linked_element.keydown(function(e) {
      $this.val(linked_element.val());
    });

    $this.on('change', function(e) {
      if ($this.data('datepicker')) {
      	var date = $this.datepicker('getDate');
      	if (date) {
      	  var value = moment(date).format('YYYY-MM-DD');
      	  linked_element.val(value);
      	  linked_element.trigger('keydown');
      	}
      }
    });
  });

  $('.form-async').on('keyup', function() {
    $("#async-waiting").show();
  });

  $('.search-select').select2({
    dropdownParent: $("#myModal .modal-body.panel-body"),
    theme: "bootstrap"
  });

  $('.froala').froalaEditor({
    height: 240,
    imageUploadURL: '/public/uploads/editor',
    imageUploadMethod: 'POST'
  });
}

function getCookie(cname) {
  var name = cname + "=";
  var decodedCookie = decodeURIComponent(document.cookie);
  var ca = decodedCookie.split(';');

  for(var i = 0; i <ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) == ' ') {
        c = c.substring(1);
      }
      if (c.indexOf(name) == 0) {
        return c.substring(name.length, c.length);
      }
  }

  return "";
}
