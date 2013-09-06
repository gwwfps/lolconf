angular.module \lolconf, [\ngRoute \ngAnimate] .config !($route-provider) ->
  $route-provider.when '/:partialName',
    template-url: (params) -> "partials/#{params.partial-name || 'index'}.html"
