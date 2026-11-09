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
- Engage a Marsh Scavenger and then a tougher Mire Stalker with attack, heavy attack, guard, telegraphed attacks, and stamina management.
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
- B: use bandage
- V: heavy attack
- T: trade near the scout
- C: craft with gathered materials
- K: open disciplines and spend skill points with keys 1/2/3
- F1: field manual
- F5: save; F9: load
- Esc: close a panel / return to menu

## Expanded expedition systems
- The campaign links Greyfen Marsh, the Drowned Road, and Old Ironroot Mine. Each region resets its local contract and cache while retaining character progression.
- Quartermaster trading converts crowns into healing draughts or bandage bundles near the scout.
- Field crafting converts herbs and scrap into draughts or bandages. Caches replenish materials in each region.
- Successful skill training, quartermaster purchases, and field crafting consume a world turn, preserving the same enemy-response rule as movement and combat.
- Adjacent enemies telegraph a committed attack one turn before resolving it. Road Wights drain stamina on a hit; Cistern Brutes and Ashen Knights can inflict bleeding. Enemy intent and archetype survive save/load.
- Save format version 3 stores region, crafting resources, explored map cells, and discipline ranks while accepting version-1 and version-2 saves.

## Design boundaries
This is the first complete vertical slice, not the full commercial-scale game. Future systems can add deeper injury locations, additional equipment slots, larger procedural regions, more enemy archetypes, and richer dialogue without breaking the playable loop.


## Character disciplines (save format version 3)
Level-ups award one spendable skill point. The K panel offers three passive disciplines, each capped at rank 2:
- Iron Vitality: +5 maximum health per rank, immediately restoring the same amount.
- Weapon Mastery: +1 weapon damage per rank for standard and heavy attacks.
- Stone Bulwark: +1 armor defense per rank.
Ranks and spent points persist in version-3 saves; older saves default all ranks to zero. Starting a genuinely new expedition resets level, attributes, and discipline ranks.
