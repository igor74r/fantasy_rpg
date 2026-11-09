extends SceneTree

func _initialize() -> void:
	call_deferred("_run_smoke_tests")

func _run_smoke_tests() -> void:
	var game_script: Script = load("res://scripts/game.gd")
	assert(game_script != null, "game script must load")
	var game: Variant = game_script.new()
	root.add_child(game)
	game._new_game()
	assert(game.player_max_hp == 30, "fresh expedition resets max health")
	assert(game.max_stamina == 8, "fresh expedition resets stamina")
	assert(game.skill_points == 0, "fresh expedition resets skill points")
	assert(game.combat_log.size() == 1, "fresh expedition starts a fresh field log")

	var herb_node: Vector2i = game._resource_node_positions()["herbs"]
	game.player = herb_node + Vector2i.LEFT
	var turn_before_herbs := game.turn
	game._interact()
	assert(game.herbs == 2 and game.gathered_nodes.has("0:herbs"), "herb patch yields two herbs and is marked gathered")
	assert(game.turn == turn_before_herbs + 1, "foraging consumes a world turn")
	game._interact()
	assert(game.herbs == 2 and game.turn == turn_before_herbs + 1, "gathered herb patch cannot be harvested twice")
	var scrap_node: Vector2i = game._resource_node_positions()["scrap"]
	game.player = scrap_node + Vector2i.LEFT
	game._interact()
	assert(game.scrap == 2 and game.gathered_nodes.has("0:scrap"), "salvage node yields two scrap")
	game.herbs = 0
	game.scrap = 0
	game.gathered_nodes.clear()
	game.player = Vector2i(3, 8)

	game.skill_points = 3
	var turn_before_training := game.turn
	game._buy_skill(0)
	assert(game.turn == turn_before_training + 1, "successful training consumes a world turn")
	game._buy_skill(1)
	game._buy_skill(2)
	assert(game.vitality_rank == 1 and game.player_max_hp == 35 and game.player_hp == 35, "Iron Vitality applies health")
	assert(game.weapon_rank == 1, "Weapon Mastery rank is recorded")
	assert(game.bulwark_rank == 1 and game.armor_defense == 2, "Stone Bulwark applies armor")
	assert(game.skill_points == 0, "training spends one point per rank")

	game.player = Vector2i(8, 8)
	game._interact()
	assert(game.cache_open and game.armor_defense == 4, "cache armor upgrade preserves Stone Bulwark")
	game.skill_points = 1
	game._buy_skill(0)
	assert(game.vitality_rank == 2 and game.player_max_hp == 40, "disciplines can reach rank two")
	game.player = Vector2i(4, 4)
	game.coins = 8
	var potions_before_trade := game.potions
	var turn_before_trade := game.turn
	game._trade()
	assert(game.potions == potions_before_trade + 1 and game.coins == 0, "quartermaster trade grants purchased draught")
	assert(game.turn == turn_before_trade + 1, "successful trade consumes a world turn")
	game.herbs = 2
	game.scrap = 1
	var potions_before_craft := game.potions
	var turn_before_craft := game.turn
	game._craft()
	assert(game.potions == potions_before_craft + 1 and game.herbs == 0 and game.scrap == 0, "field crafting consumes its ingredients")
	assert(game.turn == turn_before_craft + 1, "successful crafting consumes a world turn")
	game.skill_points = 1
	var turn_before_invalid_training := game.turn
	game._buy_skill(99)
	assert(game.skill_points == 1 and game.turn == turn_before_invalid_training, "invalid discipline cannot spend a point or consume a turn")
	game._buy_skill(0)
	assert(game.vitality_rank == 2 and game.skill_points == 1, "mastered discipline cannot consume points")

	game.player = Vector2i(5, 5)
	game.enemy_pos = Vector2i(6, 5)
	game.enemy_alive = true
	game.enemy_windup = false
	game.enemy_style = "drainer"
	game.enemy_power = 5
	game.player_hp = game.player_max_hp
	game.stamina = 6
	seed(42)
	var hp_before_windup := game.player_hp
	game._advance_turn()
	assert(game.enemy_windup and game.player_hp == hp_before_windup, "adjacent enemy telegraphs before attacking")
	game.player_guard = true
	game._advance_turn()
	assert(not game.enemy_windup, "enemy resolves its telegraphed attack on the following turn")
	assert(game.stamina == 5, "Road Wight drains two stamina after a hit, then turn recovery restores one")
	game.enemy_style = "crusher"
	game.enemy_windup = false
	game.player_guard = false
	game.enemy_phase = 0
	game.enemy_name = "MARSH SCAVENGER"
	game.enemy_alive = true
	game.experience = 0
	game.coins = 0
	game._resolve_enemy_defeat()
	assert(game.enemy_phase == 1 and game.enemy_alive, "first defeat spawns regional champion")
	assert(game.coins == 6 and game.experience == 35, "first defeat grants rewards")
	game._resolve_enemy_defeat()
	assert(not game.enemy_alive and game.contract_complete, "second defeat completes encounter")
	assert(game.coins == 17, "second defeat grants escalated reward")

	game._advance_region()
	assert(game.region_index == 1, "campaign advances to second region")
	assert(game.enemy_phase == 0 and game.enemy_alive, "new region resets encounter phase")
	assert(game.vitality_rank == 2 and game.weapon_rank == 1 and game.bulwark_rank == 1, "disciplines persist between regions")

	game.enemy_windup = true
	game.enemy_style = "drainer"
	game.gathered_nodes["1:herbs"] = true
	game._save_game()
	game.enemy_windup = false
	game.enemy_style = "bleeder"
	game.gathered_nodes.clear()
	game.vitality_rank = 0
	game.weapon_rank = 0
	game.bulwark_rank = 0
	game._load_game()
	assert(game.vitality_rank == 2 and game.weapon_rank == 1 and game.bulwark_rank == 1, "game save/load restores all discipline ranks")
	assert(game.enemy_windup and game.enemy_style == "drainer", "game save/load restores enemy intent and archetype")
	assert(game.gathered_nodes.has("1:herbs"), "game save/load restores depleted regional resource nodes")
	var restored: Dictionary = SaveSystem.read()
	assert(int(restored.get("vitality_rank", 0)) == 2, "vitality rank survives save/load")
	assert(int(restored.get("weapon_rank", 0)) == 1, "weapon rank survives save/load")
	assert(int(restored.get("bulwark_rank", 0)) == 1, "bulwark rank survives save/load")
	assert(bool(restored.get("enemy_windup", false)) == game.enemy_windup, "enemy intent persists in save data")
	assert(str(restored.get("enemy_style", "")) == game.enemy_style, "enemy archetype persists in save data")

	for legacy_version in [1, 2]:
		var legacy_config := ConfigFile.new()
		legacy_config.set_value("meta", "version", legacy_version)
		legacy_config.set_value("run", "data", {"skill_points": 2})
		assert(legacy_config.save("user://ashen_marches.save") == OK, "legacy fixture writes")
		var legacy_data: Dictionary = SaveSystem.read()
		assert(int(legacy_data.get("skill_points", 0)) == 2, "version-%d save remains readable" % legacy_version)
		assert(not legacy_data.has("weapon_rank"), "legacy save defaults new discipline ranks")
		game._load_game()
		assert(game.vitality_rank == 0 and game.weapon_rank == 0 and game.bulwark_rank == 0, "version-%d load defaults new discipline ranks" % legacy_version)

	game.queue_free()
	DirAccess.remove_absolute(ProjectSettings.globalize_path("user://ashen_marches.save"))
	print("PASS: progression, disciplines, combat rewards, region transition, and save compatibility")
	quit(0)
