angular.module \lolconf .config !($provide) ->
  $provide.decorator '$exceptionHandler', ($delegate, LC-logger) ->
    !(exception, cause) ->
      $delegate exception, cause
      LC-logger.error exception.message, {
        exception: exception
        cause: cause
      }
