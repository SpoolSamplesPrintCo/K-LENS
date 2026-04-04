# K-LENS Development Log
### Technical Notes & Progress Tracking (PRIVATE LAB)

---

## ✅ Accomplishments (Phase 1-6: Infrastructure, Solar, & Autonomous Persistence)
- [x] **Architecture:** Standardized `/scripts/` sub-folder logic for binary/script isolation.
- [x] **Bridge Confirmed:** Klipper-to-Linux shell bridge fully operational via absolute `/home/biqu/` paths.
- [x] **Engine v2.0 (Standalone):** **SUCCESS.** Decoupled engine handles 6 hardware parameters with dynamic `VERBOSE` passing for silent operation.
- [x] **Anti-Flicker Hardening:** Baked `power_line_frequency=2` (60Hz) into core initialization for SV08 LED environments.
- [x] **Solar Intelligence v2.0:** **VERIFIED.** Transitioned from hardcoded values to dynamic `.ini` coordinate parsing. Logic now supports Day/Night state detection for Montreal.
- [x] **Update Automation:** **SUCCESS.** Resolved Moonraker "Dirty Repo" errors via `git fetch --all` and `reset --hard` logic.
- [x] **State Persistence (The Bootstrap):** **COMPLETE.** Successfully implemented `klens_init.sh` to "inject" saved `.ini` values into Klipper variables on startup, bypassing the unreliable `save_variables` system.
- [x] **Zero-Collision Logic:** K-LENS now operates in a "Sandbox" mode, ensuring no interference with underlying printer configuration files.
- [x] **Bash-Hardening:** Explicitly migrated all shell commands to `bash` to support advanced logic gates `[[ ]]` on BTT-CB1 hardware.
- [x] **Status Reporting:** `KLENS_STATUS` macro finalized to output all 7 hardware parameters + session states to the console.
- [x] **Autonomous Monitoring:** **SUCCESS.** Deployed the `_KLENS_HEARTBEAT` looping macro (30-minute intervals) for seamless day-to-night transitions during long-haul prints.
- [x] **Mainsail UI Integration:** **COMPLETE.** 18-button "Mission Control" dashboard mapped with logical grouping and visual "Bake" (Save) commitment.

---

## 🚀 The Path Forward: "The Hardware Polish & Fading"
- [ ] **The Gradient Engine:** Evolve the Solar Logic from a "Hard Switch" to a "Weighted Fade" based on sun elevation degrees (+10° to -6°).
- [ ] **Hardware Audit:** Execute `v4l2-ctl -d /dev/video0 -l` to verify digital `brightness` range vs. `backlight_compensation`.
- [ ] **Adaptive Floor Tuning:** Evaluate if the new Base 150 (Day) to calibrated Night Bias provides enough clarity for high-speed SV08 travel.
- [ ] **Mainsail Skinning:** (Low Priority) Apply custom Hex color codes to Primary/Secondary buttons for a "Pro-Camera" aesthetic.
- [ ] **Geo-Universal Logic:** Finalize "Template + Bake" installer to inject `$USER` (pi/biqu/mks) into absolute paths for public release.

---

### 🧪 SV08 Hardware Variance Profile (Mapped DNA)
- **Host User:** Standardized to `/home/biqu/` for SV08/CB1 builds.
- **Exposure Target:** Base 150 (Day) | **350** (Night Floor - Calibrated).
- **V4L2 Controls:** `exposure_time_absolute` (1-5000), `brightness` (-64 to 64), `gain` (0-100), `white_balance_temperature` (2000-10000).
- **Anti-Flicker:** `power_line_frequency=2` (Critical for 60Hz power grids/LED flicker).
- **Control ID:** Confirmed `auto_exposure=1` for Manual and `3` for Auto.
- **Persistence:** Hybrid logic—`.ini` for long-term storage | `_KLENS_VARIABLES` for volatile session state.

---

## 🏁 Hardware Validation Protocol (Final Tuning)
1. **Solar Test:** **SUCCESS.** (Montreal coordinates correctly parsed from `klens_config.ini`).
2. **Bootstrap Test:** **SUCCESS.** (Persistent variables successfully restore from disk after FIRMWARE_RESTART).
3. **Verbose Toggle:** **SUCCESS.** (Engine noise silenced during Pressure Advance debugging).
4. **Heartbeat Loop:** **ACTIVE.** (Transitioning from Night-to-Day confirmed via `delayed_gcode`).

---
*Project Status: Infrastructure Decoupled. Logic Hardened. Autonomous Solar Monitoring Engaged.*
