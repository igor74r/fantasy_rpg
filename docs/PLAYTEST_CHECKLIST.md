# Ashen Marches — End-to-End Playtest

Run from a clean Godot 4.3+ editor using F6 or F5.

## Fresh expedition
- [ ] Start a new expedition from the title screen.
- [ ] Move with WASD and arrow keys; confirm blocked cells cannot be entered.
- [ ] Approach and interact with the scout; accept the contract.
- [ ] Open the cache; confirm equipment, crowns, draughts, bandages, herbs, and scrap are awarded once.
- [ ] Open the pack; verify equipment, consumables, resources, level, and bleeding state are readable.

## Combat and survival
- [ ] Fight the first creature with standard attacks and verify stamina cost.
- [ ] Use a heavy attack and verify its higher damage and stamina cost.
- [ ] Guard and verify stamina recovery plus reduced incoming damage.
- [ ] Defeat both creatures; verify the second enemy uses the region's configured name, health, and power.
- [ ] Verify XP, crowns, and level-up rewards are granted for each defeated creature.
- [ ] Use a draught and bandage; verify health restoration and bleeding removal.
- [ ] Confirm death presents a restart path.

## Campaign
- [ ] Return to the scout and collect the contract reward.
- [ ] Reach the western exit and verify the campaign advances to the Drowned Road instead of ending early.
- [ ] Repeat the contract loop in the Drowned Road and Old Ironroot Mine.
- [ ] Confirm the final exit presents the campaign completion screen.

## Persistence
- [ ] Save with F5, restart the application, and load with F9.
- [ ] Verify player stats, equipment, inventory, resources, enemy phase/health, contract state, region, and explored map are restored.
- [ ] Load a version-1 save and verify missing version-2 fields fall back to safe defaults.

## Test evidence
Record Godot version, platform, and any failing step here after an actual run. A static code review is not a substitute for this runtime playtest.
