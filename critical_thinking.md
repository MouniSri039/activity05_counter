# Activity 05 — Critical Thinking

## Q1 — Specify and Falsify an Invariant

Two invariants describe the counter and history model. First, after every user event, including a rejected event, the counter must remain within the inclusive range 10–150. Second, the history must contain only previously displayed counter states created by accepted changes; a rejected action must not add a new history entry.

The transition model is:

40
  |
  | Increase / Decrease / Slider
  v
next value
  |
  +---- invalid (<10 or >150) ----> reject + feedback
  |
  +---- valid ---------------------> history.add(previous)
                                      |
                                      v
                                  counter = next

I tested this model using boundary and overshoot cases. At 10, pressing Decrease left the counter at 10 and displayed the range message. At 150, pressing Increase left the counter at 150 and displayed the same message. I also tested an overshoot from 140 with an increment of 20. The attempted result was 160, but the counter stayed at 140 and the rejected action did not create an invalid history entry. These observations support both invariants.

For the mutation demonstration, the important protection is the condition in `_moveTo()` that rejects an invalid next value before `setState()`:

`if (!_isValidValue(nextValue)) { ... return; }`

A single-condition mutation that changes this condition to accept invalid values would allow a value outside the 10–150 range to reach the state update. For example, changing the condition from rejecting an invalid value to accepting it would allow an attempted value of 160 to be stored. The first invariant would then fail because the displayed counter could become 160. The history could also contain the previous state even though the transition should have been rejected.

The smallest repair is to restore the original guard so invalid values return before `setState()`:

`if (!_isValidValue(nextValue)) {`
`  _showMessage('Counter must stay between 10 and 150.');`
`  return;`
`}`

This demonstrates why validation must happen before state mutation. The invariant is not only a final-state rule; it also applies to rejected events. A rejected action should leave the meaningful state and history unchanged.

My instrumented trace is therefore:

`140 + 20 → 160 → reject → counter 140 → history unchanged`

and, under the faulty condition:

`140 + 20 → 160 → accepted → counter 160 → invariant violated`

The working implementation uses the guard-before-mutation pattern to prevent this failure.

---

## Q2 — Evaluate a Competing State Model

The current implementation uses a snapshot-based undo model. Whenever a valid counter change occurs, the previous counter value is stored in `_history`. For example, if the counter changes from 40 to 47 and then to 54, history contains 40 and 47. Undo removes the most recent snapshot and restores it.

An alternative is an event-based model. Instead of recording the previous value, the application could record the user's intent, such as `+7`, `-7`, or a slider movement. Undo would then need to interpret those events in reverse.

| Concern | Snapshot-based model | Event-based model |
|---|---|---|
| Invalid input | Easy to reject before recording | Event must also be rejected |
| Boundary rejection | No snapshot is added | Event must not be recorded |
| Slider movement | Exact previous value is saved | Slider intent/value must be recorded |
| Undo | Directly restores previous value | Must reverse/reconstruct event |
| Future redo | Needs additional stack | Events can support replay |
| Complexity | Simple | More complex |
| Exact restoration | Direct | Requires replay logic |

The working app provides evidence for the snapshot model. I tested valid slider movement and Undo. After moving the slider, the previous counter state was stored in history. Undo restored the previous counter value, the slider matched the restored value, and the history presentation remained consistent. This is useful because slider movement does not naturally behave like a simple `+7` or `-7` event. The user can move directly from one value to another.

Invalid input also supports the snapshot approach. Empty input, 0, -4, and 2.5 were rejected while the previous valid increment remained unchanged. Similarly, an attempted move beyond 150 was rejected before a history record was created. This keeps history meaningful because it represents states that actually existed.

A small probe that challenges the choice is to make several slider movements and then undo them one at a time. The observed behavior was that each Undo restored the exact previous value. This is straightforward with snapshots because the previous value is already available. An event model would need to store enough information about each slider movement to reproduce the same restoration behavior.

The snapshot model therefore fits the constraints discovered in this implementation because the assignment emphasizes reversible history, rejected actions, and slider consistency. An event-based model could become useful if the application later required sophisticated redo, auditing, or replay of user intent, but it would introduce additional reconstruction logic. For the current counter, storing previous valid states keeps Undo simple and directly connected to the state the user actually saw.