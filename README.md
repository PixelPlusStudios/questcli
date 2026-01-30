# questcli
A Dart CLI, Gamified Tak-Manager

Turn your daily tasks into a role-playing adventure! Complete quests, gain XP, face bosses, and level up — all in your terminal.

🚀 Installation
Quest is distributed as a **prebuilt executable bundle**.  

## macOS (Apple Silicon & Intel) & Linux

### 1. Download
Go to **GitHub → Releases** and download: quest.zip

Extract it. You should get a folder named `quest`.

---

### 2. Install globally
Keep the quest folder in a permanent location on your system.

Open Terminal in the directory where quest was extracted and run:

```bash
nano ~/.zshrc
```
Add the following line at the end of the file (replace with the full path to the bundle/bin folder inside your extracted quest directory):
```bash
export PATH="/full/path/to/quest/bundle/bin:$PATH"
```
Save and close the file, then run:
```bash
source ~/.zshrc
```
Close the terminal.

### 3. Verify

Open a new terminal.
```bash
quest help
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
