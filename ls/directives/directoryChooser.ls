angular.module \lolconf .directive \lcDirectoryChooser, ->
  require: '?ngModel'
  link: !(scope, element, attrs, ng-model) ->
    element.on 'change', !->
      scope.$apply !->
        ng-model.$set-view-value element.val!    
