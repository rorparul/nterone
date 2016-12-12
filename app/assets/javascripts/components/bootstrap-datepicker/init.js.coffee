$ ->

  $.fn.datepicker.defaults.format = {
    toValue: (date, format, language)->
      date
    toDisplay: (date, format, language)->
      moment(date).locale(language).format('L')
  }

  # change value of data-linked element
  $("input[data-linked]").each (i)->
    $this = $(this)
    linked_element = $($this.data("linked"))
    console.log linked_element

    linked_element.keydown (e)->
      $this.val(linked_element.val())

    $this.change (e)->
      if $this.data('datepicker')
        date = $this.datepicker('getDate')
        if date
          value = moment(date).format('YYYY-MM-DD')
          linked_element.val(value)
          linked_element.trigger('keydown')
