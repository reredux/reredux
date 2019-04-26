assert = require 'assert'
{createStore, connectReduxStore, rootReducer} = require '../src/index.coffee'
reduxCreateStore =  require('redux').createStore

store = createStore 'testStore', -> counter: 0
store.addMutations
  inc: (mutator) -> counter: mutator.state.counter + 1

reduxStore = reduxCreateStore(rootReducer())

connectReduxStore(reduxStore)

store.mutations.inc()

assert.equal(store.getState().counter, 1)
