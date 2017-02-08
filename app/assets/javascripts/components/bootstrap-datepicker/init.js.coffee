$ ->

  $.fn.datepicker.defaults.format = {
    toValue: (date, format, language)->
      date
    toDisplay: (date, format, language)->
      moment(date).locale(language).format('L')
  }

