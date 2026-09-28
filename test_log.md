# Activity 05 — Counter Test Log

## Test 1 — Lower Boundary

- Starting value: 10
- Increment: 7
- Action: Pressed Decrease at the lower boundary
- Observed ending value: 10
- Observed message: "Counter must stay between 10 and 150."
- Result: PASS
- Observation: The counter did not move below 10 and the rejected action did not create an invalid history entry.

## Test 2 — Upper Boundary

- Starting value: 150
- Increment: 7
- Action: Pressed Increase at the upper boundary
- Observed ending value: 150
- Observed message: "Counter must stay between 10 and 150."
- Result: PASS
- Observation: The counter did not move above 150 and the rejected action did not create an invalid history entry.

## Test 3 — Overshoot

- Starting value: 140
- Increment: 20
- Action: Pressed Increase, which would produce 160
- Observed ending value: 140
- Observed message: "Counter must stay between 10 and 150."
- Result: PASS
- Observation: The entire action was rejected before the counter or history was changed.

## Test 4 — Invalid Input

- Starting valid increment: 7
- Actions tested: empty input, 0, -4, and 2.5
- Observed result: Each invalid input was rejected and the previous valid increment remained unchanged.
- Observed message: "Enter a positive whole number."
- Result: PASS
- Observation: Invalid input did not corrupt the stored increment.

## Test 5 — Undo Chain

- Starting value: 40
- Increment: 7
- Actions: Three valid increases followed by three Undo actions
- Observed sequence: 40 → 47 → 54 → 61, then Undo restored 54 → 47 → 40
- Result: PASS
- Observation: Undo restored one previous counter state at a time and removed the corresponding history entries. An additional Undo when history was empty was harmless and displayed the appropriate feedback.

## Test 6 — Slider Consistency

- Starting value: 40
- Action: Moved the slider to another value and then pressed Undo
- Observed result: The counter returned to the previous value, the slider position matched the counter, and the history presentation was consistent.
- Result: PASS
- Observation: The counter, slider, and history remained synchronized after Undo.

## Checkpoint Observations

### Checkpoint 1
Moving the slider changed both the displayed counter value and the history line. Each valid slider movement recorded the previous counter value.

### Checkpoint 2
Empty input, 0, -4, and decimal input were rejected while preserving the previous valid increment. An increase that would exceed 150 was rejected before changing the displayed state or history.

### Checkpoint 3
The counter displayed red at 10, black between 11 and 90, and green above 90. User interactions that change state use setState() so Flutter rebuilds the widgets using the updated state.