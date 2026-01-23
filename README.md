# questcli
A Dart CLI, Gamified Tak-Manager

Turn your daily tasks into a role-playing adventure! Complete quests, gain XP, face bosses, and level up — all in your terminal.

🚀 Installation

## Step 1: Download the Application Bundle

Go to the [Releases](https://github.com/PixelPlusStudios/questcli/releases/tag/v1.0.0) page on GitHub.

Under the latest version, download the `.zip` or `.tar.gz` file for your operating system:

*   **macOS (Apple Silicon/Intel):** `quest-macos-*.zip`
*   **Windows:** `quest-windows-*.zip`
*   **Linux:** `quest-linux-*.tar.gz`

---

## Step 2: Extract the Files

Extract the contents of the downloaded archive file. You will see a new folder (e.g., `quest-bundle`) that contains `bin` and `lib` subdirectories.

Move this `quest-bundle` folder to a permanent, safe location on your computer.

*   **Suggested Location (macOS/Linux):** `/usr/local/share/`
*   **Suggested Location (Windows):** `C:\Program Files\`

---

## Step 3: Add to System PATH (Run Globally)

This step allows you to run the `quest` command from *any* folder in your terminal.

### 🍎 macOS and Linux

1.  **Open your terminal** and open your shell configuration file. This is usually `.zshrc` (macOS) or `.bashrc` (Linux):
    ```bash
    nano ~/.zshrc
    # or nano ~/.bashrc
    ```

2.  **Add the `bin` path** to the bottom of the file (adjust the path to where you moved the bundle):
    ```bash
    export PATH="$PATH:/usr/local/share/quest-bundle/bin"
    ```

3.  **Save and Restart:** Save the file (`Ctrl+O`, `Enter`, `Ctrl+X`). Close and reopen your terminal window (or run `source ~/.zshrc`) for the changes to apply.

### 🪟 Windows

1.  **Open "Environment Variables"**: Search for "Environment Variables" in the Start menu and select "Edit the system environment variables".

2.  **Edit the Path Variable**: In the "System Properties" window, click the **Environment Variables...** button. Under "User variables", select the `Path` variable and click **Edit...**.

3.  **Add the `bin` path**: Click **New** and paste the full path to your `bin` folder (e.g., `C:\Program Files\quest-bundle\bin`).

4.  **Save:** Click OK on all windows to save the changes. Close and reopen your Command Prompt or PowerShell window.

---

## Step 4: Verify and Run

Open any new terminal or command prompt window. Type the command name to verify it works:

```bash
quest --help
```

🎮 Getting Started

```bash
quest begin
```

This will:
Initialize your player stats (HP, XP, Potions, Level).
Begin a new day in your adventure.

Quest Menu
Once the game starts, you can interact via a menu:

```bash
quest menu
```
End the Day

```bash
quest end
```
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

Download the latest version from the Releases page
Replace the old binary with the new one.

🎉 Enjoy Your Adventure!

Turn your daily life into a fun RPG. Complete quests, face bosses, and become the ultimate adventurer — all from your terminal!
