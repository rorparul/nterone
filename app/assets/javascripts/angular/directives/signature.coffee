angular
  .module 'nterone'
  .directive 'signature', (User)->
    templateUrl: 'directives/signature.html'
    link: (scope, element, attrs)->

      User.get(1)
        .then (user)->
          scope.name = [user.firstName, user.lastName].join(' ')
          scope.job_title = user.business_title
          scope.phone = user.contact_number

      scope.logos = [
        { value: gon.logo_10_years, label: "<img src='"+gon.logo_10_years+"'/>" }
        { value: gon.logo_base, label: "<img src='"+gon.logo_base+"'/>" }
      ]

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
