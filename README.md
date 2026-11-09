# Ashen Marches

A top-down, turn-based dark-fantasy survival RPG built with Godot 4.x and GDScript.

## Current playable slice

- Explore the Greyfen marsh with tile-by-tile, turn-consuming movement.
- Complete regional contracts against escalating pairs of creatures, from marsh scavengers to the horrors of Old Ironroot Mine.
- Tactical combat: standard attacks, stamina-costing heavy strikes, guard, armor mitigation.
- Character progression: experience, levels, permanent health/stamina gains, and a spendable three-discipline skill tree (K).
- Equipment: find a Fen-forged sword and Marshguard coat in the supply cache.
- Survival: bleeding wounds, healing draughts, bandages, and stamina recovery.
- Three linked regions: Greyfen Marsh, the Drowned Road, and Old Ironroot Mine, with escalating encounters and regional contracts.
- Regional foraging and salvage: gather herbs and scrap from marked field nodes once per region with `E`; nodes remain depleted after saving/loading. Quartermaster trading near the scout (`T`) and field crafting (`C`) turn those materials into supplies.
- Persistent region, crafting materials, inventory, and progression; version-3 saves accept older version-1 and version-2 saves.

## Run

Open `project.godot` in Godot 4.3 or newer and run the project (F6/F5). The GitHub Actions workflow runs a headless progression smoke test on pushes and pull requests.

## Controls

- WASD / arrows: move one tile
- Space: standard attack (2 stamina)
- V: heavy attack (4 stamina)
- G: guard and recover stamina
- E: interact with nearby NPC/cache/exit
- I: inventory
- H: use healing draught
- B: use bandage (stops bleeding and heals)
- T: trade near the scout/quartermaster
- C: craft from herbs and scrap
- K: spend skill points on Iron Vitality, Weapon Mastery, or Stone Bulwark (two ranks each)
- F1: field manual
- F5 / F9: save / load

## Project rules

Read `AGENTS.md` before making changes. See `docs/GAME_DESIGN.md` for design scope.

## License

Original code and placeholder art are MIT licensed. No proprietary Stoneshard assets or content are included.
