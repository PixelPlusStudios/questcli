# questcli
A Dart CLI, Gamified Tak-Manager

Turn your daily tasks into a role-playing adventure! Complete quests, gain XP, face bosses, and level up — all in your terminal.

🚀 Installation
Mac / Linux

Download the latest release

Make it executable:

-> chmod +x quest

(Optional) Move it to a folder in your PATH so you can run it anywhere:

-> sudo mv quest /usr/local/bin/quest

=====================================================================
Windows

Download quest.exe from the Releases page

Place it in a folder of your choice.

Add the folder to your system PATH (optional) so you can run quest from any terminal.

=====================================================================

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

Download the latest version from the Releases page
Replace the old binary with the new one.

🎉 Enjoy Your Adventure!

Turn your daily life into a fun RPG. Complete quests, face bosses, and become the ultimate adventurer — all from your terminal!
