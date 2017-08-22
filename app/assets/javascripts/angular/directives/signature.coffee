angular
  .module 'nterone'
  .directive 'signature', ()->
    templateUrl: 'directives/signature.html'
    link: (scope, element, attrs)->

      scope.embed = element.find("div.signature").html()

      observer = new MutationObserver (mutations)->
        scope.embed = element.find("div.signature").html()

      observer.observe element[0],
        childList: true,
        subtree: true

      # Select all if embed is focused
      element.find("textarea.embed").on "click", ()->
        textarea = this
        setTimeout ()->
          textarea.select()
        , 10



