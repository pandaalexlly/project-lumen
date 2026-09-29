# Facility World Layout

## Direction

Project Lumen's world is a connected abandoned research facility. Curiosity, physical access, and the player's model of its rules replace the prototype's ordered teaching chambers. The world should offer evidence before explanation and let revisiting a familiar place produce new possibilities.

No area is named after a mechanic in player-facing presentation. The names below describe believable facility functions and are development labels only.

## Spatial structure

```text
        Containment Works      Signal Array
                    \          /
Records Wing --- Operations Atrium --- Power and Cooling
                         |
                Isolated incident chamber
                    (initial playable space)
```

The Operations Atrium is the central facility hub. It should be readable as a place that once coordinated people, power, containment, and remote instruments—not as a menu with four puzzle doors. Sightlines, dormant machinery, inaccessible service routes, and changing facility state should invite return visits.

The four surrounding knowledge areas have different environmental purposes:

- **Records Wing:** archives, abandoned offices, incident evidence, and conflicting institutional accounts.
- **Power and Cooling:** generators, coolant circulation, maintenance access, and the infrastructure that can support artificial observation.
- **Containment Works:** transfer bays, storage, test infrastructure, and physical safeguards built around unstable objects.
- **Signal Array:** remote instruments, observation feeds, antenna control, and the remains of facility-wide coordination.

These purposes may expose related facts, but no wing owns a single mechanic. Useful evidence should cross area boundaries so that knowledge, rather than linear completion, changes what a player attempts.

## Opening space

The player wakes in an isolated incident chamber adjoining the atrium through a short service vestibule. The chamber contains a sealed bulkhead, an observation booth, damaged diagnostic equipment, a containment plinth, and signs that the room was abandoned during a test.

The existing Quantum Cube begins on the plinth. Its other possible states are embedded in plausible object-sized clearings: behind a diagnostic rack, inside the booth, and on an abandoned gurney. None is labelled or presented as a destination pad. Looking directly at the Cube holds it in place; breaking sight for long enough lets it occupy another available state. Searching for it reveals the room's history while allowing the player to infer that observation affects its state.

TASK-027 established local restoration: relocation exposes the service control beneath the Cube, and the existing interaction restores work lighting, instrument supplies, and ventilation. TASK-030 extends that same activation to the bulkhead motor and hub circulation lighting. The player can now walk into the Operations Atrium and return, while four future wing approaches remain sealed. See [the intended discovery flow](AWAKENING_DISCOVERY_FLOW.md) and [hub foundation](CENTRAL_HUB_FOUNDATION.md) for validation and the current boundary.

## Progression principles

- Restoration changes the facility's physical state; it is not a collection of conventional keys or upgrades.
- Evidence appears in architecture, equipment state, object placement, and consequences before explanatory text.
- Returning with a better mental model should matter more than completing a prescribed sequence.
- Routes may reconnect to the hub from unexpected directions, preserving spatial continuity.
- Explicit tutorial language, mechanic-revealing titles, and UI rule explanations are excluded.
