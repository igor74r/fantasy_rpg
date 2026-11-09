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
- [ ] Lure an enemy adjacent; verify its committed attack is telegraphed for one turn before it resolves.
- [ ] Verify Road Wight stamina drain and Cistern Brute/Ashen Knight bleeding effects.
- [ ] Save while an enemy is winding up; reload and verify the intent is preserved.
- [ ] Defeat both creatures; verify the second enemy uses the region's configured name, health, and power.
- [ ] Verify XP, crowns, and level-up rewards are granted for each defeated creature.
- [ ] Earn a skill point, open disciplines with K, and train Iron Vitality, Weapon Mastery, and Stone Bulwark with 1/2/3.
- [ ] Verify each discipline caps at rank 2, changes the relevant stat, and cannot spend points after mastery.
- [ ] Buy Stone Bulwark before opening the supply cache; verify the armor upgrade preserves the perk bonus.
- [ ] Use a draught and bandage; verify health restoration and bleeding removal.
- [ ] Confirm death presents a restart path.

## Campaign
- [ ] Return to the scout and collect the contract reward.
- [ ] Reach the western exit and verify the campaign advances to the Drowned Road instead of ending early.
- [ ] Repeat the contract loop in the Drowned Road and Old Ironroot Mine.
- [ ] Confirm the final exit presents the campaign completion screen.

## Persistence
- [ ] Save with F5, restart the application, and load with F9.
- [ ] Verify player stats, equipment, inventory, resources, skill ranks, enemy phase/health, contract state, region, and explored map are restored.
- [ ] Load version-1 and version-2 saves and verify missing version-3 discipline fields default to rank zero.

## Test evidence
Record Godot version, platform, and any failing step here after an actual run. A static code review is not a substitute for this runtime playtest.
