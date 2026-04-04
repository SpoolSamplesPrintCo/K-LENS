# 📸 KLENS: K-Logic Enhanced Native Sight
### Adaptive Vision-Control Engine Optimized for Sovol SV08
**Developer:** J (@SpoolSamplesPrintCo) | **Assistant:** Gemini

> [!WARNING]
> **DEVELOPMENT BUILD (v0.11.4.0):** This branch contains active experiments. Expect frequent updates and potential breaking changes.

---

## 🚀 The Philosophy: "Beauty by Default"
Standard Klipper camera setups often suffer from "Exposure Hunting," resulting in flickering timelapses and washed-out prints. **KLENS** treats your printer like a cinematic set.

* **The Beauty Profile (Default):** A high-contrast, punchy cinematic look (-280 Bias) that makes the SV08 chamber look professional while idle or printing dark/colored materials.
* **Hex-Hunter Automation:** The suite scans your G-code filename. If it detects a White Filament Hex Code (#FFFFFF), it automatically drops the exposure to -400 Bias to preserve fine model detail.

## 🛠 Compatibility & Requirements
* **Hardware:** Optimized for Sovol SV08 (Internal USB Camera).
* **Host:** BTT-CB1 / Raspberry Pi (Debian-based).
* **Software:** Klipper with gcode_shell_command installed via KIAUH.

---

## 📥 Installation
1. SSH into your printer.
2. Navigate to config and clone:
   cd ~/printer_data/config
   git clone -b development https://github.com/SpoolSamplesPrintCo/klens.git
3. Run the installer:
   cd klens
   chmod +x install.sh
   ./install.sh
4. Update printer.cfg:
   Add [include klens/klens_macros.cfg] to the top of your file and Restart Klipper.

---

## 🎮 The Dashboard
* **KLENS_STATUS**: View current sensor values in the console.
* **KLENS_SAVE**: Permanently save temporary tweaks to the engine config.
* **K_LENS_AUTO_PROFILE**: Place this in your START_PRINT macro to engage the Hex-Hunter.
* **KLENS_TOGGLE_BLACK**: Manual override to swap between "Beauty" (-280) and "White" (-400) modes.

---
© 2026 SpoolSamplesPrintCo. Produced in collaboration with System G.
