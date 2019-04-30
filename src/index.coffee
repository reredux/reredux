_connect = require('react-redux').connect
{mountEventHelpers, logger} = require './helpers'

stores = {}
_reduxStore = null

connect = (component, stores) ->
  mapState = (state) ->
    result = {}
    for store in stores
      result[store.name] =
        state: state[store.name]
        actions: store.actions
        mutations: store.mutations
    result
  _connect(mapState)(component)

mutator = (state) ->
  m = -> {...state, ...arguments[0]}
  m.state = state
  m

connectReduxStore = (reduxStore) ->
  _reduxStore = reduxStore
  for storeName, store of stores
    store.mutations.reset()
  reduxStore

rootReducer = (next) -> (state, action) ->
  unless action.type.indexOf('reredux') is 0
    nextState = next?(state, action) || {}
    return {...state, ...nextState}

  [storeName, actionName] = action.type.split('.').splice 1
  logger(storeName, actionName, action.args)
  reducer = stores[storeName].reducers[actionName]
  storeState = state[storeName]

  {...state, "#{storeName}": reducer(mutator(storeState), action.args...)}

createStore = (name, initialState) ->
  store = stores[name] =
    name: name
    initialState: initialState
    actions: {}
    mutations: {}
    reducers: {}

  store.addMutation = (mutationName, reducer) ->
    store.reducers[mutationName]  = reducer
    store.mutations[mutationName] = ->
      _reduxStore.dispatch
        type: "reredux.#{store.name}.#{mutationName}"
        args: [...arguments]
    mountEventHelpers(store.mutations[mutationName])

  store.addMutation 'reset', store.initialState

  store.getState = -> _reduxStore.getState()["#{store.name}"]
  store.addActions = (actionsObject) -> Object.assign store.actions, actionsObject
  store.addMutations = (mutationsObject) -> store.addMutation mutationName, reducer for mutationName, reducer of mutationsObject
  store.connect = (component) -> connect component, [store]

  store

module.exports = {createStore, rootReducer, connectReduxStore, connect}
