angular
  .module 'nterone'
  .directive 'selectLabel', ()->
    templateUrl: 'directives/select-label.html'
    scope:
      model: "="
      value: "@"
    link: (scope, element, attrs)->
      scope.label       = attrs.label
      scope.model       = scope.value

      scope.$watch 'value', (oldValue, newValue)->
        if oldValue != newValue
          scope.model = scope.value

  .directive 'radioLabel', ($sce)->
    templateUrl: 'directives/radio-label.html'
    scope:
      model: "="
      radios: "="
      value: "@"
    link: (scope, element, attrs)->
      scope.label = attrs.label

      for radio in scope.radios
        radio.label = $sce.trustAsHtml(radio.label)

      scope.setCurrent = (radio)->
        scope.model = radio.value

      scope.setCurrent scope.radios[0]
