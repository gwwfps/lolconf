angular.module \lolconf .directive \lcModal, ($root-scope, $compile) ->
  template-url: 'templates/modal.html'
  transclude: true
  link: !(scope, element, attrs) ->
    {defer} = require 'lodash'

    element.detach!
    body = $ document.body
    content = element.find '.modal-content'

    $root-scope.$on \modal:show, !(event, template-name) ->
      inner = $ '<div></div>'
      inner.attr 'ng-include', "'modals/#{template-name}.html'"
      content.html inner
      ($compile inner) event.target-scope
      body.append element
      defer -> body.add-class \modal-active

    $root-scope.$on \modal:hide, !(event) ->
      body.remove-class \modal-active      
      content.html ''
      element.detach!

angular.module \lolconf .directive \lcModalClose ->
  !(scope, element, attrs) ->
    element.click !->
      scope.$emit \modal:hide
