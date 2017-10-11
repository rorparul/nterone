angular
  .module 'nterone'
  .directive 'inputLabel', ()->
    templateUrl: 'directives/input-label.html'
    scope:
      model: "="
    link: (scope, element, attrs)->
      scope.label       = attrs.label
      scope.placeholder = attrs.placeholder || scope.label

      if attrs.type == "website"
        scope.type = "text"
        scope.placeholder = "http://"
      else
        scope.type        = attrs.type || "text"

  .directive 'textareaLabel', ()->
    templateUrl: 'directives/textarea-label.html'
    scope:
      model: "="
      value: "@"
    link: (scope, element, attrs)->
      scope.label       = attrs.label
      scope.type        = attrs.type || "text"
      scope.model       = scope.value
      scope.placeholder = attrs.placeholder || scope.label

      scope.$watch 'value', (oldValue, newValue)->
        if oldValue != newValue
          scope.model = scope.value

