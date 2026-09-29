# First External Playtest Protocol

## Purpose

Test whether a first-time player builds and transfers the intended mental model
without explanation. This is an observation session, not a tutorial or a test
of the participant. Run the complete F5 flow from the main menu to the ending.

## Before the session

Record the participant's relevant background without collecting identifying
information: familiarity with first-person controls, puzzle games, spatial
puzzles, and knowledge-driven games. Ask permission to take notes and to use
the anonymous local telemetry log.

Tell the participant only:

> This is an early first-person puzzle prototype. Use WASD and the mouse. E
> interacts with devices, R restarts the current area, Escape releases the
> mouse, and left-click captures it again. Try to find a way through. Please
> say what you are thinking when you are comfortable doing so.

Do not mention observation, looking away, Quantum movement, artificial
observation, candidate destinations, or constraint elimination.

## Facilitator rules

- Sit where the screen is visible but do not point at objects or controls.
- Record actions and exact player language before interpreting it.
- Do not confirm a hypothesis while the player is still testing it.
- If intervention becomes necessary, record the time, room, exact prompt, and
  what the player had already tried. Begin with “What have you noticed?”
- Ask room questions only after the player has exited that room. Do not use the
  intended terminology unless the player has already used it.
- A wrong relocation is not automatically a failed attempt. The Combined
  shutter state is the slice's only explicit gameplay failure; restarts and
  abandoned approaches are recorded separately.

## Main Menu

Observe whether the participant can begin unaided and notices the control
summary. Confusion indicators are searching for settings, trying to click the
control text, or beginning without understanding E/R.

After starting, ask only if something was unclear:

- “Was there anything you expected to find on the menu but did not?”

## Observation Lab

### Observe

- First reaction to the Cube changing after it leaves view.
- Whether the participant deliberately repeats look/turn/wait experiments.
- Whether they apply the same hypothesis to the QuantumDoor.
- Whether Application becomes intentional experimentation or repeated random
  waiting.

### Evidence of understanding

- Predicts that sustained loss of sight permits a change.
- Uses looking back to check or interrupt the behavior.
- Deliberately manipulates sight lines rather than treating movement as random.
- Applies the rule to the door without being told it is the same kind of object.

### Evidence of confusion

- Attributes movement to proximity, elapsed time alone, collision, or a hidden
  switch after contradictory evidence.
- Repeats the same view without changing the observation condition.
- Treats the Cube and door as unrelated mechanics.

### Ask after exit

- “What do you think made the objects change?”
- “What experiment gave you the strongest evidence?”
- “What would you predict if you kept watching one continuously?”

## Stabilization Discovery

### Observe

- Whether the participant first tries the rule learned in Observation Lab.
- Whether failed look-away behavior directs attention to the active Beam.
- Whether Beam power experiments produce a revised model.

### Evidence of understanding

- Identifies the Beam as another source of observation or stabilization.
- Predicts that turning it off restores ordinary look-away behavior.
- Distinguishes Beam state from player gaze rather than replacing the old rule.

### Evidence of confusion

- Repeats look-away attempts without investigating what differs in the room.
- Describes the Beam only as a teleport trigger or physical force.
- Cycles the switch without making a prediction about the Cube.

### Ask after exit

- “What was different from the previous room?”
- “What do you think the Beam was doing?”
- “What would you expect with the Beam on while you looked away?”

## Stabilization Destination

### Observe

- Whether the player notices the Beam initially covers an empty destination.
- Whether they compare repeated outcomes before redirecting.
- Whether they use Beam redirection as a deliberate exclusion rather than as a
  direct movement command.

### Evidence of understanding

- States that an observed empty position cannot receive the Cube.
- Predicts how moving the Beam changes the set of possible destinations.
- Redirects the Beam away from the desired destination or onto an unwanted one.

### Evidence of confusion

- Expects the Beam to pull, push, or teleport the Cube directly.
- Treats every relocation as unconstrained randomness.
- Redirects repeatedly without checking which positions are covered.

### Ask after exit

- “Why did the Cube avoid some positions?”
- “What changed when you redirected the Beam?”
- “Can the Beam affect a place where the Cube is not currently present?”

## Stabilization Combined

### Observe

- Whether the first orange result reads as a consequence rather than arbitrary
  punishment.
- Whether the recovery console is found and understood without prompting.
- Whether the player notices that recovery preserves Beam OFF.
- Whether the successful attempt follows a stated plan to exclude orange C.

### Evidence of understanding

- Explains the failure using the available destination set.
- Recognizes recovery as restoring the experiment, not erasing the learned
  Beam state.
- Uses player gaze to eliminate C and predicts G before release.

### Evidence of confusion or frustration

- Assumes the shutters mean a dead end and immediately presses R.
- Expects recovery to reset every state, then cannot explain why Beam remains
  off.
- Repeats the same failed view without changing a constraint.
- Solves accidentally and cannot explain why the second result differed.

### Ask after exit

- “Why did the first attempt close the shutters?”
- “What did recovery change, and what did it leave unchanged?”
- “Why did the Cube go to green on the successful attempt?”
- “Did failure help you form a plan, or did it feel like lost progress?”

## Field Observation Site

### Observe

- Whether the QuantumDoor and Beam are recognized without teaching-room text.
- Whether the participant reads the breach, mezzanine, receiver, relay, and
  service gate as purposeful parts of the environment.
- Whether they recover from wrong Cube states without relying on R.
- Whether they combine Beam coverage and personal sight into one planned safe
  destination set.

### Evidence of knowledge transfer

- Reuses the QuantumDoor rule without prompting.
- Investigates Beam direction and environmental sight lines before brute force.
- Chooses the mezzanine because of what it can reveal and conceal.
- Explains success as eliminating other possible destinations.

### Evidence of confusion

- Searches for a new mechanic instead of applying learned rules.
- Treats the Field Site as disconnected scenery with no functional landmarks.
- Brute-forces relocations without checking Beam coverage or sight lines.
- Reaches the relay accidentally and cannot reconstruct the solution.

### Ask after exit

- “Which ideas from earlier areas did you reuse here?”
- “Why did you choose that observation position?”
- “What prevented the Cube from appearing at the other locations?”
- “Which environmental objects helped you understand where to go?”

## Ending and debrief

Ask in this order, without offering answer choices:

- “How do you think anomalous objects work?”
- “How does the Beam change that rule?”
- “Which room changed your understanding the most?”
- “Where were you confused, frustrated, or unsure what had changed?”
- “Did any prompt, label, color, or effect give away too much?”
- “What strategy surprised you by working?”
- “How would you describe the game to another player?”

## Telemetry retrieval

Each run writes newline-delimited JSON under
`user://playtest/session-<timestamp>.jsonl`. Use Godot's project data folder to
retrieve it after the session. It records room entry/completion order, elapsed
time, restarts and their reason, explicit Combined failures, and successful
interactions. It records no input stream, camera path, free text, or personal
information. Keep facilitator notes as the primary evidence; telemetry provides
timing and event corroboration, not an explanation of player intent.

## Required build checks

- Launch from the exported package and begin only from the main menu.
- Check keyboard movement, mouse look, E, R, Escape release, and click recapture.
- Test 1280x720 and one non-16:9 window for unobstructed UI.
- Complete every room and confirm the dedicated ending, revisit, and menu flows.
