angular.module \lolconf .directive \lcClose, ->
  link: !(scope, element, attrs) ->
    element.on \click, !->      
      window.close!
