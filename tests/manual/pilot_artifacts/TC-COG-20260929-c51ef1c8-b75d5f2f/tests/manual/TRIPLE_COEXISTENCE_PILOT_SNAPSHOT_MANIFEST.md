# Triple Coexistence — Logistics Pilot Snapshot Manifest

**Purpose:** identify the exact source-and-document package to copy and verify for the two **unscored logistics pilots**. This is a manifest of the current workspace, **not** an exported build, a copied pilot artifact, a production build system, or a GO signature. The prototype's scenes/scripts are intentionally untracked; a clean checkout of the Git commit below is **not** this playable snapshot. Human comprehension remains **UNVALIDATED**.

| Identity field | Captured value |
| --- | --- |
| Snapshot label | `TC-COG-20260929-c51ef1c8-b75d5f2f` (source identity only; not a pilot-machine artifact ID) |
| Verification time / verifier | 2026-09-29 19:46 +08:00; Codex read-only file hashing on the current workspace. Human release verifier: **pending**. |
| Source root | `F:\project\project-lumen` |
| Git HEAD | `fb5eeeed8183e82bc07b20ea68e1d480cc530fc2` — insufficient alone because the working tree has modified and untracked runtime files. |
| Pilot entry scene | `res://scenes/tests/triple_coexistence_cognitive_probe.tscn` — launch directly, **not F5**. |
| Runtime-source set | 162 files; aggregate SHA-256 `c51ef1c884e72b2c5cb36ba8d0b4cb0806009ce5c15e92b6a68bf53d883a5d7a`. |
| Required-document set | 15 files listed below; aggregate SHA-256 `b75d5f2fd9025d4a8066323509daef6a4bda4922f5670681c780b437a32d51dc`. This manifest itself is excluded to avoid a self-hash. |
| Actual pilot-machine copy / export | **Not yet created or verified.** Artifact path/ID: ______; copy/archive SHA-256: ______; verifier/date: ______. |

## Exact prototype files

The cognitive scene instances the base proof scene; the base scene instances the existing player scene. The two world scripts generate/control those greyboxes. Both validators are **staff-only** and are not the player scene. `project.godot` is included because it defines project settings and autoload context. The file hashes below matched the [freeze sign-off](TRIPLE_COEXISTENCE_PILOT_FREEZE_SIGNOFF.md) during the operational recheck.

| File (relative to project root) | Role | SHA-256 |
| --- | --- | --- |
| `project.godot` | Project/runtime context | `2b2ebd8d35448eff8bf5b27fae67d1b1bb1b095b149b51bc8dcc9b2d51de24d4` |
| `scenes/tests/triple_coexistence_cognitive_probe.tscn` | Direct pilot scene | `dfaf71a4f3a2dfdb3aefaf864658a446fe8e79435e7851183343e9f50196af3e` |
| `scenes/tests/triple_coexistence_probe.tscn` | Instanced three-stack proof scene | `db2027fc03f480f8de142f68b5f2be51b67e1707b2bc88b2b7891cb99075bced` |
| `scripts/world/triple_coexistence_cognitive_probe.gd` | Visit/handoff wrapper | `c038f27a2b2fe5f8b83b378e5970e11f19d33e474381913f9ac7ca1538f702ad` |
| `scripts/world/triple_coexistence_probe.gd` | Fixed-stack greybox | `8d8066778acec636d97ef8249e94acb921e997c3246eb0a8f9fed6e5a1245fb8` |
| `scripts/world/triple_coexistence_cognitive_validation.gd` | Cognitive route/geometry validator | `8a37e35224426370ae08ce8f66a3d4d11985a7cd297ce33fa7472b27b8595b50` |
| `scripts/world/triple_coexistence_validation.gd` | Base proof validator | `45f27dd382c92f57761b38aa8db5a91aaa34bb50b7dba28313c9de77feced54e` |
| `scenes/player/player.tscn` | Instanced player scene | `754f81672625ccca08c3601c0f230b3d1f6f7b5874f74214154549fb6ccfd903` |
| `scripts/player/player_controller.gd` | Player movement/look dependency | `1a2a38e6be7cada638e9af09e8222c2f7bbe961db471255d46ad446300aa7ca3` |
| `scripts/interaction/interaction_component.gd` | Player-scene script dependency | `9e15c16f0857df2fab87f6c0702f5d9df838bc9a99bb4df655082d25bb9d525f` |

The scene chain above is **not** the entire Godot dependency tree. The 162-file runtime digest covers other scripts, scenes, `.gd.uid` files, resources, and project files outside `docs/` and `tests/`; transfer them with their relative paths intact. At capture, `project.godot` and `scripts/interaction/interaction_component.gd` were modified; the two triple scenes and four triple world scripts/validators were untracked. Their status is a packaging fact, not permission to reset or omit them.

## Required documents and hashes

All paths are relative to the project root. The [document authority index](../../docs/world/PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md) and [canonical rulebook](../../docs/world/PROJECT_LUMEN_CANONICAL_SPATIAL_RULEBOOK.md) establish world authority; the **current cognitive blind run sheet** is the operative participant script. The older proof-only blind protocol is historical/reference material, not an alternate moderator script.

| Document | Pilot role | SHA-256 |
| --- | --- | --- |
| [PROJECT_LUMEN_CANONICAL_SPATIAL_RULEBOOK.md](../../docs/world/PROJECT_LUMEN_CANONICAL_SPATIAL_RULEBOOK.md) | World-rule authority, staff only | `be40cd12065e04c878b2d87cc488a25a3364c8832ee479784eb14ecebd1618c2` |
| [PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md](../../docs/world/PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md) | Authority/precedence, staff only | `ba141c9326a8e79091ac6bb3b94cef6ce1c083798a46a5026a68f96ff6f2f78b` |
| [TRIPLE_COEXISTENCE_COGNITIVE_VALIDATION_SCENARIO.md](../../docs/world/TRIPLE_COEXISTENCE_COGNITIVE_VALIDATION_SCENARIO.md) | Intended cognitive test, staff only | `f2f0d64e544e3fc449aba141065df6ef44db80c25484eba31f4e07e991b688d4` |
| [TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md](../../docs/world/TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md) | Base technical result, staff only | `1373bf062c8313bb3ef776d967c78fb1e67cd4356358e58b5695ae3267870506` |
| [TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md](../../docs/world/TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md) | Cognitive technical result, staff only | `5a5fba2782d2fcb872f77a9dd69ff9247ba02c6cf5cf5c1beacfe7dbe2c4c0eb` |
| [TRIPLE_COEXISTENCE_PLAYTEST_RESULT_ANALYSIS_TEMPLATE.md](../../docs/world/TRIPLE_COEXISTENCE_PLAYTEST_RESULT_ANALYSIS_TEMPLATE.md) | Later analysis, not a player prompt | `5c47abc4098ae8bbbb6832c59598217b0e629d3e95cec6ca623f16d1c8976de7` |
| [TRIPLE_COEXISTENCE_MENTAL_MODEL_SCORING_REVISION.md](../../docs/world/TRIPLE_COEXISTENCE_MENTAL_MODEL_SCORING_REVISION.md) | Level 0–3/vertical-unit interpretation | `a4d25b705b03f40423363f4fee284a8b6ad050860e99cdfdf2009da426d48ad2` |
| [TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md](../../docs/world/TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md) | Diagnose pilot process results | `5d2a21d2ee878e8f2edd908d345014be68fc6752dd09c9f17d9fb18a2fda1c73` |
| [TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md](TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md) | **Operative moderator script** | `af9a883011ebefd7badc2e2bf5493db0f498bc39ce31c53d54f830cf20216bff` |
| [TRIPLE_COEXISTENCE_COGNITIVE_PILOT_CHECKLIST.md](TRIPLE_COEXISTENCE_COGNITIVE_PILOT_CHECKLIST.md) | Pilot setup/process | `a64f128b3f3248e4b4ba46701252df8d8a5978c17b88003d6093ce956377d987` |
| [TRIPLE_COEXISTENCE_PLAYER_SESSION_TRACKING_SHEET.md](TRIPLE_COEXISTENCE_PLAYER_SESSION_TRACKING_SHEET.md) | Raw session record | `3285119ba904921b94357fc3bdc5210a444c3b003b26e08cd7d95a9bb6dd3159` |
| [TRIPLE_COEXISTENCE_PLAYTEST_EXECUTION_CHECKLIST.md](TRIPLE_COEXISTENCE_PLAYTEST_EXECUTION_CHECKLIST.md) | Per-session workflow | `aa81efbd965ff8c1fe497fd52b889c57771b895ff9475d930943f6eecd39a909` |
| [TRIPLE_COEXISTENCE_PRE_PILOT_FREEZE_CHECKLIST.md](TRIPLE_COEXISTENCE_PRE_PILOT_FREEZE_CHECKLIST.md) | Pre-pilot hard stops | `4d59df36218173f6485c30f3af3c225c5e717409afd877fe17afc8ebc6a7b1cb` |
| [TRIPLE_COEXISTENCE_PILOT_FREEZE_SIGNOFF.md](TRIPLE_COEXISTENCE_PILOT_FREEZE_SIGNOFF.md) | Current NO-GO/GO sign-off record | `ab6c75a35387bf938212fa382e75d33612761ebe697e4bdea567eeae3b9fd914` |
| [TRIPLE_COEXISTENCE_PRE_PILOT_READINESS_REVIEW.md](TRIPLE_COEXISTENCE_PRE_PILOT_READINESS_REVIEW.md) | Independent readiness findings | `05899a8b8321b83d4f2017663a8523aee82fe4b9d2f102f201f49ac357feb888` |

This **15-document digest excludes this manifest** and any future session records. If the sign-off document is later updated with a dated human GO decision, its hash and the document-set digest will change; record that as a new document revision without silently calling it the original snapshot.

## Environment and prior validation

- Authoring/check host: 64-bit Windows (`Microsoft Windows NT 10.0.26200.0`) with PowerShell `5.1.26100.9444`. **Pilot machine, display, input, recording setup, and storage location are not yet attested.**
- Godot on the check host: `4.7.2.stable.official.ed1daf0bf`; executable at `C:\Users\熊俊豪\AppData\Local\Programs\Godot\4.7.2\godot.exe`, SHA-256 `ab1824f85bfde8e0e4128182c000c4003a3e042245b2967848d089b2a04b22424`. Record the executable identity on the actual pilot machine separately.
- Local operational check recorded in the [freeze sign-off](TRIPLE_COEXISTENCE_PILOT_FREEZE_SIGNOFF.md): Godot headless editor import and direct cognitive scene launch exited 0; cognitive and base validators exited 0 and printed `PASS`. Cognitive validator traversed H0 → H1 → H2 → H0 and A/B; base validator checked H0 access, fixed stacks, sightlines, and parallax. Host certificate-store, `user://logs`, and editor-settings save warnings did not coincide with parser, missing-resource, or validator failures. This does **not** replace a visible-window/input/recording check on the pilot machine.
- Platform assumption for reproduction: the same Godot version, compatible 64-bit Windows runtime/input environment, and an exact project-source copy with relative paths preserved. Cross-platform or exported-build equivalence has **not** been verified.

## Digest definition and use

The two aggregate digests use the same method, applied to different path sets:

1. From the project root, enumerate files with `rg --files --hidden --no-ignore`, excluding `.git/**`, `.godot/**`, `docs/**`, and `tests/**` for the **runtime** set. For the **document** set, use exactly the 15 paths in the table above; do not add this manifest.
2. Sort relative paths with PowerShell `Sort-Object`. For each path, replace backslashes with forward slashes and form one line: `<relative-path> <lowercase-SHA-256-of-file>`.
3. Join lines with LF (`\n`), append one final LF, encode as UTF-8, and SHA-256 that byte sequence. Record file count and digest. A count or digest mismatch means the copy is **not** this snapshot until investigated.

For the actual pilot package, copy the full project source tree **including ignored and untracked files** and the 15 required documents, preserving relative paths. Exclude `.git/` and regenerate `.godot/` locally; neither directory is in the runtime digest. The manifest is a checksum record, **not** a replacement for the files, a Git branch, or a promise that an archive already exists. Do not run the pilot from a clean checkout of `fb5eeeed8183` alone. After copying, recompute both digests and the critical hashes, record the destination artifact path/hash and verifier in the sign-off, then perform the direct scene launch and pilot-machine smoke/recording checks. Any mismatch, substituted engine, or modified test-affecting file requires a new snapshot identity and comparability review; do not silently patch the copy.

Pilot copy location/ID: ______  Copy/archive SHA-256: ______  Runtime count/digest rechecked: ______  Document count/digest rechecked: ______  Godot version/hash: ______  Verifier/date: ______

## Known limits and release boundary

- The floor-level receiver handoff is a **test-only** surrogate, not a production QER destination or door rule. The experiment does not implement Left/Right room exchange, Beam/camera observation, or final-game travel semantics.
- Inboard and exterior repair marks match as motifs, not continuous structural joins. The lower Awakening tiers first appear from the exterior proof. Candidate A retains a bridge-like reading risk; B can read as ordinary wings. Automated sightlines do not cover every free-look position or prove a player will notice them.
- The current sign-off remains **NO-GO** for logistics pilots until the copied artifact, visible play, screen/audio capture, secure storage/consent, moderator, primer policy, and two unbriefed participants are verified. A matching digest clears only the **artifact-identity** part of that gate.
- Technical success establishes that the isolated scene can run and its validators pass. It does **not** establish that players form or revise the intended spatial model. **Human comprehension is UNVALIDATED.**
