# Quest CLI

A gamified terminal task tracker. Turn your daily tasks into a role-playing adventure: complete quests, gain XP, face bosses, and level up — all in your terminal.

---

## Installation

Pre-built binaries are on [GitHub Releases](https://github.com/YOUR_USERNAME/questcli/releases). Each archive contains:

- `bin/quest` (or `bin/quest.exe` on Windows) — the executable  
- `lib/` — native libraries (sqlite3)  
- `assets/` — sounds and art  

**Keep `bin/`, `lib/`, and `assets/` together** (or add the extracted folder’s `bin` to PATH).

### macOS

1. Download `quest-<version>-darwin-arm64.zip` (Apple Silicon) or `quest-<version>-darwin-amd64.zip` (Intel).
2. Unzip, then in Terminal:

```bash
chmod +x quest-*/bin/quest
# Option A: add bin to PATH (e.g. in ~/.zshrc)
export PATH="$PATH:$(pwd)/quest-<version>-darwin-arm64/bin"

# Option B: install for all users (copy entire folder, then link bin)
sudo cp -R quest-* /usr/local/quest && sudo ln -sf /usr/local/quest/bin/quest /usr/local/bin/quest
```

3. Run:

```bash
quest --help
quest begin
```

### Linux

1. Download `quest-<version>-linux-amd64.zip` from [Releases](https://github.com/YOUR_USERNAME/questcli/releases).
2. Unzip, then:

```bash
chmod +x quest-*/bin/quest
export PATH="$PATH:$(pwd)/quest-<version>-linux-amd64/bin"
```

3. Run `quest --help` or `quest begin`.

### Windows

1. Download `quest-<version>-windows-amd64.zip` from [Releases](https://github.com/YOUR_USERNAME/questcli/releases).
2. Unzip to a folder (e.g. `C:\Tools\quest`).
3. Add `C:\Tools\quest\bin` to your [PATH](https://learn.microsoft.com/en-us/windows/win32/procthread/environment-variables).
4. In PowerShell or Command Prompt:

```powershell
quest --help
quest begin
```

> **Note:** On Windows, sound uses `.wav` only; `.mp3` effects are skipped.

---

## One-line install (macOS / Linux)

Replace `VERSION` and `PLATFORM` (e.g. `1.0.0`, `darwin-arm64`):

```bash
curl -sL https://github.com/YOUR_USERNAME/questcli/releases/download/vVERSION/quest-VERSION-PLATFORM.zip -o q.zip && unzip -o q.zip && rm q.zip && chmod +x quest-*/bin/quest && export PATH="$PATH:$(pwd)/quest-VERSION-PLATFORM/bin"
```

Then run `quest --help`.

---

🎮 Getting Started
Start the game

-> quest begin

This will:
Initialize your player stats (HP, XP, Potions, Level).
Begin a new day in your adventure.

Quest Menu
Once the game starts, you can interact via a menu:

-> quest menu

End the Day

->quest end

Ends your current day.
Checks for unfinished quests.
Triggers a boss fight if all requirements are met.
Updates your level and location.

🗺️ Map & Progress

Your progress is visualized with an HP bar and world map.
Completed locations are marked ✅.
Bosses are indicated with ⚔️.
Locked locations are 🔒.

💖 Player Stats

HP (Hit Points): Survive battles and quests.
XP (Experience Points): Earn by completing tasks or resting. Convert to potions.
Potions: Restore HP when in danger.
Level: Increases as you survive days. Unlocks new locations.
Place: Your current location in the game world.

⚔️ Boss Fights

Each location has a boss with difficulty scaling.
Boss fights are randomized via a dice roll, factoring your HP and level.
Win to gain XP and HP bonuses.
Lose, and you lose HP — careful, adventurer!

🎨 Assets

ASCII/Emoji visuals are included for boss and player animations.
HP bars are colored for quick readability.

📢 Tips

Save your progress by keeping your player database intact.
Rest or drink water to gain potions.
Plan your tasks carefully — unfinished quests can make boss fights harder.

🛠️ Requirements

No Dart SDK needed for end-users (standalone executable).
Terminal capable of ANSI colors is recommended for best visuals.

📦 Updates

Download the latest version from the [Releases](https://github.com/YOUR_USERNAME/questcli/releases) page and replace the old binary (and `assets` folder if needed).

---

## Building / Releasing

**Prerequisites:** [Dart SDK](https://dart.dev/get-dart) 3.10+.

The project uses `sqlite3`, which relies on build hooks, so you must use `dart build cli` (not `dart compile exe`). The first build needs network so sqlite3 can fetch native libraries.

- **macOS / Linux:** `./scripts/build.sh` → `release/quest-<version>-<os>-<arch>.zip`
- **Windows:** `.\scripts\build-windows.ps1` → `release\quest-<version>-windows-amd64.zip`

To publish a release: push a tag `v*` (e.g. `git tag v1.0.0 && git push origin v1.0.0`). The [GitHub Actions workflow](.github/workflows/release.yml) runs `dart build cli` on macOS, Linux, and Windows and uploads the zips to the release.

> **Replace `YOUR_USERNAME`** in this README with your GitHub username or org so install links work.

🎉 Enjoy Your Adventure!

Turn your daily life into a fun RPG. Complete quests, face bosses, and become the ultimate adventurer — all from your terminal!
