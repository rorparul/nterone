angular
  .module 'nterone'
  .directive 'signature', (User)->
    templateUrl: 'directives/signature.html'
    link: (scope, element, attrs)->

      User.get(1)
        .then (user)=>
          scope.name = [user.firstName, user.lastName].join(' ')
          scope.job_title = user.businessTitle
          scope.phone = user.contactNumber

      scope.logos = [
        { value: gon.logo_10_years, label: "<img src='"+gon.logo_10_years+"'/>" }
        { value: gon.logo_base, label: "<img src='"+gon.logo_base+"'/>" }
      ]

      scope.facebook = "https://www.facebook.com/pages/NterOne-Corporation/214212902033061"
      scope.twitter = "https://twitter.com/NterOne"
      scope.linkedin = "http://www.linkedin.com/company/nterone"

      hostname = window.location.hostname.split('.');
      tld = hostname[hostname.length - 1]

      if tld == 'ca' || tld == 'com'
        scope.link1 = "https://www.nterone." + tld + "/articles/nterone-awarded-cisco-americas-learning-partner-of-the-year-for-2016"
        scope.link1_text = "NterOne Awarded Cisco Americas Learning Partner of the Year - 2016"
        scope.link2 = "https://www.nterone." + tld + "/articles/nterone-corporation-wins-cisco-innovation-award"
        scope.link2_text = "NterOne Corporation Wins Cisco Innovation Award - 2015"
        scope.link3 = "https://www.nterone." + tld + "/articles/nterone-wins-acceleration-learning-partner-of-the-year"
        scope.link3_text = "NterOne Wins Acceleration Learning Partner of the Year - 2014"
      else
        scope.link1 = "https://www.nterone.la/articles/nterone-recibe-el-premio-cisco-americas-learning-partner-del-ano-2016"
        scope.link1_text = "NterOne Recibe el Premio Cisco Americas Learning Partner del Año - 2016"
        scope.link2 = "https://www.nterone.la/articles/nterone-corporation-gana-el-premio-a-la-innovacion-de-cisco"
        scope.link2_text = "NterOne Corporation Gana el Premio a la Innovacion de Cisco - 2015"
        scope.link3 = "https://www.nterone.la/articles/nterone-wins-acceleration-learning-partner-of-the-year-2014"
        scope.link3_text = "NterOne Gana Acceleration Learning Partner del Año - 2014"


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
