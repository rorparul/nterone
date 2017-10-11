angular
  .module "nterone"
  .factory "User", ($http,  RailsResource) ->

    class User extends RailsResource
      @configure url: '/api/v1/users', name: 'user'