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

	game.skill_points = 3
	game._buy_skill(0)
	game._buy_skill(1)
	game._buy_skill(2)
	assert(game.vitality_rank == 1 and game.player_max_hp == 35 and game.player_hp == 35, "Iron Vitality applies health")
	assert(game.weapon_rank == 1, "Weapon Mastery rank is recorded")
	assert(game.bulwark_rank == 1 and game.armor_defense == 2, "Stone Bulwark applies armor")
	assert(game.skill_points == 0, "training spends one point per rank")

	game.skill_points = 1
	game._buy_skill(0)
	assert(game.vitality_rank == 2 and game.player_max_hp == 40, "disciplines can reach rank two")
	game.skill_points = 1
	game._buy_skill(0)
	assert(game.vitality_rank == 2 and game.skill_points == 1, "mastered discipline cannot consume points")

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

	game.queue_free()
	print("PASS: progression, disciplines, combat rewards, and region transition")
	quit(0)
