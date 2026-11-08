# Repository instructions

## Product direction
- Build an original dark-fantasy, top-down, turn-based survival RPG inspired by the *design principles* of tactical RPGs; do not copy proprietary Stoneshard art, text, maps, characters, or assets.
- Engine: Godot 4.x, GDScript, Forward+ or Compatibility renderer. Keep the project runnable in a clean Godot 4 installation.
- Prioritize a complete, coherent playable vertical slice over disconnected prototypes.

## Engineering rules
- Read this file and `docs/GAME_DESIGN.md` before changing gameplay.
- Use typed GDScript where practical, explicit scene ownership, small focused scripts, and descriptive names.
- Avoid external runtime dependencies and network requirements.
- Keep gameplay data separate from presentation as the project grows.
- Every gameplay feature must have clear player feedback, keyboard access, and a documented control.
- Do not add copyrighted game assets. Use original procedural/vector art or assets with recorded licenses.
- Keep save data versioned and backward-safe where practical.
- Update README and design notes when controls, setup, or core systems change.
- Run a headless Godot parse/start check when Godot is available. Never claim a test passed unless it was actually run.
- Keep commits focused and never force-push.

## Current slice acceptance
- Main menu, playable overworld, grid movement, turn-based enemy encounter, loot, inventory, healing, NPC contract, quest completion, death/restart, and save/load.
- No placeholder buttons: every visible action must work or be clearly marked unavailable.
