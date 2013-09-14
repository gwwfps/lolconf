angular.module \lolconf .factory \LCTranslationLoader, ($q, LC-logger, LC-data) -> 
  (options) ->
    deferred = $q.defer!

    messages = LC-data.load ('lang.' + options.key)
    deferred.resolve messages

    deferred.promise
