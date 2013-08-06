angular.module \lolconf .directive \lcModal, ($root-scope) -> 
  !(scope, element, attrs) ->
    id = attrs.lc-modal
    body = angular.element 'body'
    modal = body.children '.modal-content'

    element.hide!

    $root-scope.$on \modal:show, !(event, target-id) ->
      if target-id == id
        modal.append element
        element.show!
        body.add-class \modal-active

    $root-scope.$on \modal:hide, !(event) ->
      body.remove-class \modal-active      

angular.module \lolconf .directive \lcModalClose ->
  !(scope, element, attrs) ->
    element.click !->
      scope.$emit \modal:hide    

