# ReRedux

[![Build Status](https://travis-ci.org/reredux/reredux.svg?branch=master)](https://travis-ci.org/reredux/reredux)

```
store = createStore 'counter', -> counter: 0

store.addMutations
  inc: (m, inc = 1) -> m counter: m.state.counter + inc
  
...

export default store.connect(Counter)

...

 <button
  onClick={@props.counterStore.mutations.inc.onClick}
> 
  Inc
</button>

```
