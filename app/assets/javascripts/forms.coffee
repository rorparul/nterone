$ ->

  $('body').on 'click', 'a.add_fields2', (event) ->
    time = new Date().getTime()

    regexp = new RegExp($(this).data('id'), 'g')

    $(this).before($(this).data('fields').replace(regexp, time))

    event.preventDefault()

  $('body').on 'click', 'a.remove_fields2', (event) ->
    $(this).prev('input[type=hidden]').val('1')

    $(this).closest('section').hide()

    event.preventDefault()

