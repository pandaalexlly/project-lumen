# Exploration World

This tree is the connected-world layer for Project Lumen. It is intentionally separate from `scenes/prototype/`, which remains the mechanism and regression testbed.

```text
world/
├── opening/                  # Initial isolated incident chamber
├── hub/                      # Playable central Operations Atrium
├── areas/
│   ├── records/              # Future Records Wing
│   ├── power/                # Future Power and Cooling
│   ├── containment/          # Future Containment Works
│   └── signal/               # Future Signal Array
└── environment/greybox/      # Reusable structural and dressing modules
```

The opening chamber, central Operations Atrium, and reusable greybox kit are implemented. Four sealed wing approaches provide physical context within the hub; the area directories still reserve future responsibilities without committing to final puzzles.
