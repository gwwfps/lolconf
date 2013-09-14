angular.module \lolconf, [\ngRoute \ngAnimate \pascalprecht.translate] .config !($route-provider, $translate-provider) ->
  {each} = require 'lodash'

  $translate-provider.fallback-language \en
  $translate-provider.preferred-language \en
  $translate-provider.use-loader \LCTranslationLoader

  $route-provider.when '/:partialName',
    template-url: (params) -> "partials/#{params.partial-name || 'index'}.html"
