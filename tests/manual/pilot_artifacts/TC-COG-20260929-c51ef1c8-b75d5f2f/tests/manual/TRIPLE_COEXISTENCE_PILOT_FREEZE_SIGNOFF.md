# Triple Coexistence — Logistics Pilot Freeze Sign-off Record

**Current decision: NO-GO — local runtime checks passed; pilot-site and human logistics remain unverified.** This is a release record for **two unscored logistics pilots**, not a result report. A checked repository file is not evidence that the designated test machine, recording, consent, staff, or participants are ready. Human comprehension is **UNVALIDATED**. Complete the [pre-pilot freeze checklist](TRIPLE_COEXISTENCE_PRE_PILOT_FREEZE_CHECKLIST.md) and the fields below before changing this decision to GO.

Freeze ID: **not assigned** · Source capture: **2026-09-29 15:56 +08:00** · QA owner: **unassigned** · Intended pilot A/B dates: **not scheduled**

## 1. Freeze status summary

| Item | Evidence currently available | Status for pilot release |
| --- | --- | --- |
| World/test document authority | [Authority index](../../docs/world/PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md) identifies the canonical rulebook and the [current cognitive run sheet](TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md); the older proof-only protocol is not operative. | **Identified**, staff acknowledgment pending. |
| Isolated source prototype | Scene, base proof scene, wrapper/base scripts, validators, and player dependency exist; the 10 critical source and 9 document hashes below still match. A 162-file runtime-source fingerprint is recorded below. Git HEAD alone is insufficient because the prototype files are untracked and some dependencies are modified. | **Current-workstation source identified**, not yet copied/frozen on the designated pilot machine. |
| Technical validation | [Cognitive validation record](../../docs/world/TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md) and [greybox validation](../../docs/world/TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md) report earlier passes. **Re-run on 2026-09-29:** headless editor import, direct scene launch, cognitive validator, and base validator all exited 0; both validators printed PASS. | **Local runtime pass**; visible-window and designated pilot-machine smoke checks pending. |
| Pilot procedure/materials | Run sheet, pilot checklist, execution checklist, session sheet, scoring revision, review guide, freeze checklist, and readiness review are present. Active instructions still use the three-fixed-stack model. | **Digital files present**; printing/concealment, staff rehearsal, and screen/audio recording trial pending. |
| Human result | No unbriefed sessions are evidenced by this record. | **UNVALIDATED**; no puzzle-success or player-understanding claim. |

### Operational verification update — 2026-09-29 19:31 +08:00

- **Frozen entries:** all 10 source and 9 validation/operative-document SHA-256 values in Section 2 were rechecked after the runtime pass; **19/19 matched**. Repository HEAD remained `fb5eeeed8183`; `godot --version` returned `4.7.2.stable.official.ed1daf0bf`.
- **Dependency chain:** cognitive scene → base proof scene → player scene; the scene resources reference the expected cognitive/base scripts and player controller/interaction scripts. No referenced scene/script path was missing during import or launch. The prototype scenes and world scripts are deliberately **untracked**, so a clean Git checkout at HEAD is **not** a runnable copy of this frozen source. The exact project copy, not merely the commit, must be transferred and verified for pilots.
- **Runtime source fingerprint:** 162 files selected with `rg --files --hidden --no-ignore`, excluding `.git/**`, `.godot/**`, `docs/**`, and `tests/**`; sorted by relative path with PowerShell `Sort-Object`. For each file, concatenate normalized forward-slash path, one space, lowercase file SHA-256, and newline; SHA-256 of the UTF-8 concatenation is `c51ef1c884e72b2c5cb36ba8d0b4cb0806009ce5c15e92b6a68bf53d883a5d7a`. This identifies the **current runtime-source set**, not an exported build or a verified pilot-machine copy. Include ignored/untracked files when making that copy.
- **Commands and result:** `godot --headless --path . --editor --quit` exited 0; `godot --headless --path . --quit-after 120 res://scenes/tests/triple_coexistence_cognitive_probe.tscn` exited 0; `godot --headless --path . --script res://scripts/world/triple_coexistence_cognitive_validation.gd` exited 0 with `PASS triple cognitive probe`; `godot --headless --path . --script res://scripts/world/triple_coexistence_validation.gd` exited 0 with `PASS triple coexistence`. The cognitive validator exercised area-triggered H0 → H1 → H2 → H0 handoffs, controller traversal from final H0 to A and B, all three identities, nine final sightlines, fixed transforms, and lack of a floor bridge. The base validator independently checked H0 spawn/access, A/B sightlines and parallax, and fixed stacks. `git diff --check` exited 0.
- **Host diagnostics:** Godot printed certificate-store, `user://logs`, and editor-settings save errors under the current restricted host profile. There were **no scene parser, missing-resource, validator assertion, or nonzero-exit failures** in these checks. The log/settings warnings do not demonstrate a gameplay failure, but recording/log behavior on the actual pilot account remains to be tested.
- **Documentation:** required digital moderator, session, execution, scoring, and review materials exist; a scan found deprecated M/N–P/Q names in active materials only as explicit *do-not-use* warnings. The current cognitive run sheet and document authority index, not the older proof-only protocol linked from a historical prototype note, govern the pilot.
- **Not verified by this pass:** visible-window presentation and mouse behavior on the designated pilot setup; screen/audio capture playback and clock sync; approved restricted storage/consent policy; physical room/observer concealment; named moderator; two distinct unbriefed participants; one selected primer and confidence-prompt trial policy. Do **not** mark these fields GO on the basis of headless automation.

## 2. Exact prototype and document identity

The identifiers below were read from `F:\project\project-lumen` at the source-capture time. **SHA-256 is the file-content identity**, not proof that these files were exported or run on the future test machine. Before each pilot, compare the selected build/source copy against this manifest; if any test-affecting file differs, assign a new freeze ID and review comparability. Do not commit or push to create an identity.

- Repository HEAD at capture: `fb5eeeed8183` (short ID). Working tree is **not clean**: `project.godot` and `scripts/interaction/interaction_component.gd` are modified; the two triple scenes and four triple scripts/validators below are untracked. Preserve these changes.
- Godot executable found on the authoring host: `C:\Users\熊俊豪\AppData\Local\Programs\Godot\4.7.2\godot.exe`; `godot --version` returned `4.7.2.stable.official.ed1daf0bf`; executable SHA-256: `ab1824f85bfde8e0e4128182c000c4003a3e042245b2967848d089b2a04b22424`. **Test-machine Godot identity:** ______.
- Exported/standalone build version and artifact hash: **not supplied / not verified**. If pilots use the direct Godot scene rather than an export, record that explicitly with the full project snapshot and executable identity: ______.
- Entry scene: `res://scenes/tests/triple_coexistence_cognitive_probe.tscn` launched directly in a game window. F5 runs Awakening and is **not** this test. The cognitive scene instantiates the base proof scene, which instantiates `scenes/player/player.tscn`.

| Source file (relative to repository) | Role | SHA-256 at capture |
| --- | --- | --- |
| `project.godot` | Project settings and autoload context | `2b2ebd8d35448eff8bf5b27fae67d1b1bb1b095b149b51bc8dcc9b2d51de24d4` |
| `scenes/tests/triple_coexistence_cognitive_probe.tscn` | Pilot entry scene | `dfaf71a4f3a2dfdb3aefaf864658a446fe8e79435e7851183343e9f50196af3e` |
| `scenes/tests/triple_coexistence_probe.tscn` | Instanced three-stack proof scene | `db2027fc03f480f8de142f68b5f2be51b67e1707b2bc88b2b7891cb99075bced` |
| `scripts/world/triple_coexistence_cognitive_probe.gd` | Visit/handoff wrapper | `c038f27a2b2fe5f8b83b378e5970e11f19d33e474381913f9ac7ca1538f702ad` |
| `scripts/world/triple_coexistence_probe.gd` | Fixed-stack greybox | `8d8066778acec636d97ef8249e94acb921e997c3246eb0a8f9fed6e5a1245fb8` |
| `scripts/world/triple_coexistence_cognitive_validation.gd` | Cognitive technical validator | `8a37e35224426370ae08ce8f66a3d4d11985a7cd297ce33fa7472b27b8595b50` |
| `scripts/world/triple_coexistence_validation.gd` | Base proof technical validator | `45f27dd382c92f57761b38aa8db5a91aaa34bb50b7dba28313c9de77feced54e` |
| `scenes/player/player.tscn` | Instanced player scene | `754f81672625ccca08c3601c0f230b3d1f6f7b5874f74214154549fb6ccfd903` |
| `scripts/player/player_controller.gd` | Player movement/look dependency | `1a2a38e6be7cada638e9af09e8222c2f7bbe961db471255d46ad446300aa7ca3` |
| `scripts/interaction/interaction_component.gd` | Player-scene script dependency | `9e15c16f0857df2fab87f6c0702f5d9df838bc9a99bb4df655082d25bb9d525f` |

This is a **critical-file fingerprint**, not a full transitive asset inventory. The release owner must retain an exact read-only copy or full manifest of the entire project/export actually used for both pilots, including resources/autoloads, and record its ID here: ______. Recheck the hashes above against that copy: ______ (reviewer/date).

| Validation / operative document | Role | SHA-256 at capture |
| --- | --- | --- |
| [TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md](../../docs/world/TRIPLE_COEXISTENCE_COGNITIVE_PROTOTYPE_VALIDATION.md) | Prior cognitive technical result | `5a5fba2782d2fcb872f77a9dd69ff9247ba02c6cf5cf5c1beacfe7dbe2c4c0eb` |
| [TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md](../../docs/world/TRIPLE_COEXISTENCE_GREYBOX_VALIDATION.md) | Prior base-proof technical result | `1373bf062c8313bb3ef776d967c78fb1e67cd4356358e58b5695ae3267870506` |
| [TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md](TRIPLE_COEXISTENCE_COGNITIVE_BLIND_PLAYTEST.md) | Operative moderator run sheet | `af9a883011ebefd7badc2e2bf5493db0f498bc39ce31c53d54f830cf20216bff` |
| [TRIPLE_COEXISTENCE_COGNITIVE_PILOT_CHECKLIST.md](TRIPLE_COEXISTENCE_COGNITIVE_PILOT_CHECKLIST.md) | Logistics pilot process | `a64f128b3f3248e4b4ba46701252df8d8a5978c17b88003d6093ce956377d987` |
| [TRIPLE_COEXISTENCE_PLAYTEST_EXECUTION_CHECKLIST.md](TRIPLE_COEXISTENCE_PLAYTEST_EXECUTION_CHECKLIST.md) | Per-session workflow | `aa81efbd965ff8c1fe497fd52b889c57771b895ff9475d930943f6eecd39a909` |
| [TRIPLE_COEXISTENCE_PLAYER_SESSION_TRACKING_SHEET.md](TRIPLE_COEXISTENCE_PLAYER_SESSION_TRACKING_SHEET.md) | Raw observation record | `3285119ba904921b94357fc3bdc5210a444c3b003b26e08cd7d95a9bb6dd3159` |
| [TRIPLE_COEXISTENCE_MENTAL_MODEL_SCORING_REVISION.md](../../docs/world/TRIPLE_COEXISTENCE_MENTAL_MODEL_SCORING_REVISION.md) | Level 0–3 and vertical-unit evidence | `a4d25b705b03f40423363f4fee284a8b6ad050860e99cdfdf2009da426d48ad2` |
| [TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md](../../docs/world/TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md) | Post-pilot process diagnosis | `5d2a21d2ee878e8f2edd908d345014be68fc6752dd09c9f17d9fb18a2fda1c73` |
| [PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md](../../docs/world/PROJECT_LUMEN_DOCUMENT_AUTHORITY_INDEX.md) | Authority/precedence | `ba141c9326a8e79091ac6bb3b94cef6ce1c083798a46a5026a68f96ff6f2f78b` |

## 3. Environment confirmation — on-site fields, currently unverified

| Check | Required record before GO | Verified by/date |
| --- | --- | --- |
| Test machine and OS | Machine ID: ______; OS/build: ______; test account: ______; chosen source/export path or artifact ID: ______; Godot executable/version/hash if direct scene launch: ______ | ______ |
| Game display and input | Monitor/resolution/FOV/brightness: ______; keyboard/mouse or accessibility device: ______; mouse capture/release and movement tested: ______; audio level: ______ | ______ |
| Direct scene and route smoke check | Clean relaunch; H0 → H1 → H2 → H0; H2 pause recognizable; A ramp and B ground reachable; no early triple view; actual first-view exposure legible: ______ | ______ |
| Recording | Consent procedure: ______; screen-capture tool/settings: ______; microphone/tool/settings: ______; test playback file ID: ______; video/audio and note clocks aligned: ______ | ______ |
| Storage and privacy | Approved restricted location (staff-only reference, **not** a public URL): ______; capacity/playback verified: ______; anonymous ID convention: ______; separate consent location and retention policy: ______ | ______ |
| Room and observer | Quiet room/lighting/chair: ______; participant-only game display: ______; silent observer seat and note-taking: ______; no editor, documents, prior results, or node names visible: ______ | ______ |

Do not fill these fields from the authoring machine or prior validation note. The actual pilot machine, capture chain, and storage must be checked on site.

## 4. Human-testing preparation — currently unverified

| Check | Required record before GO | Verified by/date |
| --- | --- | --- |
| Participants | Pilot A-first ID/date: ______; pilot B-first ID/date: ______; distinct unbriefed participants confirmed: ______; neutral spoiler-screen plan: ______ | ______ |
| Moderator and observer | Moderator assigned/rehearsed: ______; silent observer assigned: ______; only moderator speaks; answer-bearing materials hidden: ______ | ______ |
| Prior experience and assignment | One nonverbal observation primer/version for both pilots: ______; A/B assignment concealed until after H2 sketch: ______; same settings/assistance policy: ______ | ______ |
| Materials | Current run sheet: ______; two ID-only blank sketch sheets: ______; pens/timer: ______; session sheet and intervention log: ______; consent and debrief materials: ______; pilot-review form: ______ | ______ |
| Recording/scoring separation | `T0/T1/T2/T3/T4` capture rehearsed: ______; assigned vs actual A/B, atrium-cue vs complete-stack opportunity, and spontaneous vs prompted words recordable: ______ | ______ |

## 5. Intentionally unresolved — acceptance required, not silently settled

| Item | Pilot boundary | Accepted by/date before GO |
| --- | --- | --- |
| Human comprehension, lead-in, and A/B comparison | Unknown until clean unbriefed sessions. Pilot observations diagnose measurement, not puzzle success. | ______ |
| Production QER/door rules and final facility proof | Floor-level receiver transfer and A/B geometry are isolated test scaffolding; production destination/egress and final proof are not established here. | ______ |
| Known visual/interpretation risks | Repair motifs do not form one continuous surface; the lower tier first appears at the proof; transfers may read as loading; A may read as a bridge, B as ordinary wings. Record, do not improvise a fix during pilots. | ______ |
| Confidence prompt | Trial policy for **both** T1 and T3 during pilots: ______. Whether it remains in the scored protocol is a post-pilot decision; do not compare unmatched prompts. | ______ |
| Scored-wave scoring synchronization | The vertical-unit `V`/Level 3 revision is recorded alongside existing `I/C/E/R` during pilots. Any final protocol/form reconciliation occurs before scored recruitment, not mid-session. | ______ |

Additional unresolved item accepted for pilots (scope and owner): ______. **An empty acceptance field is not acceptance.** If an item changes participant exposure or prevents an interpretable T1/T3 record, reclassify it as a NO-GO hard stop rather than waiving it.

## 6. GO / NO-GO decision

**Present state: NO-GO pending operational verification.** The repository snapshot and prior technical record alone cannot confirm participant readiness. Change to GO only after the [pre-pilot checklist](TRIPLE_COEXISTENCE_PRE_PILOT_FREEZE_CHECKLIST.md) is complete and each field below cites evidence.

| Release criterion | Evidence / initials |
| --- | --- |
| Exact project/export artifact and Godot version verified on test machine; both pilots will use the same frozen snapshot | ______ |
| Fresh scene launch, controls, full visit route, A/B approaches, and no premature proof leak checked on site | ______ |
| Screen/audio test capture replayed; timestamps, consent, anonymous IDs, secure storage, and retention policy ready | ______ |
| Two distinct unbriefed pilots scheduled; moderator/observer assigned; one primer and confidence-prompt trial policy fixed | ______ |
| Operative document authority confirmed; old protocol excluded; complete-stack observation capture and intervention log rehearsed | ______ |
| Section 5 unresolved items explicitly accepted; no remaining hard stop | ______ |

Decision: ☐ **GO — begin two unscored logistics pilots** ☐ **NO-GO — fix and review again**  Reason/open actions: ______  Freeze/build ID: ______  QA signatory: ______  Date/time: ______

A GO here means only that the **experiment can begin testing its procedure**. After A-first and B-first pilots, use the [pilot result review guide](../../docs/world/TRIPLE_COEXISTENCE_PILOT_RESULT_REVIEW_GUIDE.md) to decide whether the *procedure* is ready for formal blind sessions. **Technical validation:** prior recorded pass, subject to current-machine confirmation. **Human comprehension validation:** **UNVALIDATED**; no claim that the puzzle works or that players understand the intended cognitive reversal.
