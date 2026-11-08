# Ashen Marches — Game Design

## Pillars
1. Deliberate tactical decisions: movement and combat advance the world turn.
2. Survival pressure: health, stamina, consumables, and dangerous terrain matter.
3. Exploration with purpose: readable landmarks, loot, and a compact contract loop.
4. Original low-resolution dark-fantasy presentation with strong silhouettes and restrained colors.

## First playable release
A compact, self-contained expedition around the ruined watchpost of Greyfen:
- Start a new run or load a local save.
- Explore a bounded wilderness map from a top-down perspective.
- Move one tile per action; hostile creatures react after player actions.
- Engage a Marsh Scavenger and then a tougher Mire Stalker with attack, heavy attack, guard, and stamina management.
- Gain experience and levels; level-ups increase maximum health and stamina.
- Loot improved weapon and armor from the supply cache; armor reduces incoming damage.
- Survive bleeding wounds with bandages and healing draughts.
- Search a supply cache for coins and a healing draught.
- Speak to the Greyfen scout, accept a contract, defeat the scavenger, and return for a reward.
- Use a healing draught, inspect inventory, save, and load.
- Death offers a restart path.

## Controls
- WASD / arrows: move one tile (consumes a turn)
- Space: attack an adjacent enemy (consumes a turn)
- G: guard (restores stamina and reduces the next incoming hit)
- E: interact with the nearest landmark/NPC/cache
- I: inventory
- H: use healing draught
- F5: save; F9: load
- Esc: close a panel / return to menu

## Expanded expedition systems
- The campaign links Greyfen Marsh, the Drowned Road, and Old Ironroot Mine. Each region resets its local contract and cache while retaining character progression.
- Quartermaster trading converts crowns into healing draughts or bandage bundles near the scout.
- Field crafting converts herbs and scrap into draughts or bandages. Caches replenish materials in each region.
- Save format version 2 stores region and crafting resources while accepting version-1 saves.

## Design boundaries
This is the first complete vertical slice, not the full commercial-scale game. Future systems can add deeper injury locations, additional equipment slots, crafting, larger procedural regions, more enemy archetypes, and richer dialogue without breaking the playable loop.
