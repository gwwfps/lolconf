data-loader = do ->
  {read-file-sync} = require 'fs'
  {load} = require 'js-yaml'
  require! 'path'

  {
    load: (name) ->
      yaml = read-file-sync (path.join 'data', (name + '.yaml')) .to-string!
      if !yaml
        return void
      load yaml
  }

angular.module \lolconf, [\ngRoute \ngAnimate \pascalprecht.translate] .config !($route-provider, $translate-provider) ->
  {each} = require 'lodash'
  init-data = data-loader.load 'init'

  each init-data.supported-languages, !(lang) ->
    messages = data-loader.load ('lang.' + lang)
    $translateProvider.translations lang, messages

  $translate-provider.fallback-language init-data.default-language
  $translate-provider.preferred-language init-data.default-language

  $route-provider.when '/:partialName',
    template-url: (params) -> "partials/#{params.partial-name || 'index'}.html"
