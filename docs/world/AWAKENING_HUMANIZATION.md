# Awakening Chamber: Humanization Pass

Current-layout note: the later discovery-pacing pass moved the service control from beneath the Cube to the maintenance side of its guarded apparatus. Relocation now opens an approach, rather than revealing the handle from the main room. The subsequent Beam/load integration made this a local power control, not a direct door release. The historical TASK-028 observations below describe the earlier arrangement. See [the current discovery flow](AWAKENING_DISCOVERY_FLOW.md).

TASK-028 develops the existing chamber as a workplace with evidence of use and abandonment. Its footprint, four Cube states, covered service handle, and restoration behavior remain intact. There are no new areas, interactions, observer types, or puzzle conditions.

TASK-029 preserves this environmental layout while refining the player-height arrival, first relocation continuity, and physical service control. See [the first-player experience pass](AWAKENING_FIRST_PLAYER_EXPERIENCE.md).

## Four functional spaces

| Space | Evidence of its former use | Exploration purpose |
| --- | --- | --- |
| Observation booth | Window-facing desk, notebook, pencil, abandoned headset, mug, displaced chair, and damaged workstation | Offers a former researcher's view of the apparatus and small details worth inspecting. |
| Maintenance bay | Drawer bench, opened instrument, internal coils, removed lid, wrench, spare fuse, rag, recorder, and exposed wall services | Gives the occluding rack a functional context and invites changes in sight line. |
| Containment floor | Anchored apparatus, actuators, pressure instrumentation, disconnected inspection equipment, damaged extraction duct, and cables | Establishes the Cube as an object people investigated while keeping its visual envelope and the restoration handle clear. |
| Facility control station | Distribution cabinet, analogue meters, inactive display, instrument housing, printout, binder, and personal bag | Offers an off-axis interest from spawn; its supply indicator responds through the existing restoration presentation. |

A coat on a wall hook, an empty document slot, loose tape, and a partly used gurney suggest interrupted routines. Paper surfaces contain no instructions or rule diagrams. Small props are scenery, with no collection or inventory behavior.

## Circulation and pacing

The shortened diagnostic rack leaves a rear maintenance passage within the original shell. Its supports are centered beneath it. The player can enter the west bay from the shared floor, inspect the bench and recorder, pass around the rear of the rack, and return beside the apparatus. The observation booth and south control station remain accessible independently.

The Cube remains visible on arrival, with other legible interests around it. The player can investigate desks, damaged infrastructure, or the bulkhead in any order. Turning and walking behind equipment uses the existing observation rules; no trigger stages a disappearance or forces a first destination.

The TASK-027 causal chain is preserved: relocation uncovers a physical service handle, and using it restores local services. The new control-station supply indicator participates in the same restoration animation. No automatic power reaction to a particular Cube destination has been added.

## Materials and light

The inspection fixture uses neutral light in place of saturated cyan. The control station has a warm task light; emergency fixtures retain practical orange lighting. Restored work lights retain their existing behavior. No objective glow or navigation marker was added.

Shared materials provide painted alloy, composite flooring, and worn wall finish with restrained surface variation. Matte fabric, aged paper, dark instrument faces, and ceramic details distinguish materials by function. Wall seams, ventilation returns, pipe brackets, cable trays, and localized leakage connect the workspaces to a common building.

Assets added: `research_workbench.tscn`, three material resources under `scenes/world/environment/materials/`, and room-specific `awakening_workspaces.tscn`. Existing modular assets, damaged equipment, and passive cameras remain in use.

## Validation

Godot 4.7.2 regression passed: all four Cube states, short-glance cancellation, covered-handle obstruction, real E interaction, restoration, existing pocket routes, the new rear loop and control-station approach, and prototype HUD visibility on scene exit. The loop initially caught a protruding rack support; supports were recentered and the player capsule sweeps passed.

Rendered 1280 by 720 views were inspected at spawn, the maintenance bench, observation desk, control station, rear passage, exposed handle, and restored room. No player-facing labels or instructions are present.

Human playtesting should establish whether players recognize the workspaces without labels, choose their own routes, connect the uncovered handle to restored services, and distinguish passive equipment from controls. Automated validation does not establish session duration or first-time understanding.
