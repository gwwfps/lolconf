angular.module \lolconf .directive \lcTooltip, ->
  tooltip = $ 'body' .find '#tooltip'
  if tooltip.length == 0
    tooltip = $ '<div id="tooltip" class="global-tooltip"></div>' .append-to ($ 'body')

  link: !(scope, element, attrs) ->
    tooltip.html scope.$eval attrs.lc-tooltip

    element.on \mouseenter, !(event) ->
      tooltip.show!
      tooltip.css left: event.page-x, top: event.page-y
    element.on \mouseleave, !(event) ->
      tooltip.hide!