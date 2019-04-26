mountEventHelpers = (action) ->
  action.onChange = ({target}) ->
    action if target.type is 'checkbox'
      target.checked
    else
      target.value
  action.onClick = -> action()
  action

logger = (storeName, actionName, args) ->
  console.groupCollapsed "#{storeName}.#{actionName}(#{args.length})"
  console.log args...
  console.groupEnd()

module.exports = {mountEventHelpers, logger}
