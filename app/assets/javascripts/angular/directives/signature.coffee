angular
  .module 'nterone'
  .directive 'signature', ()->
    templateUrl: 'directives/signature.html'
    link: (scope, element, attrs)->
      console.log 'ok'


