extends Node2D

const TILE := 42
const MAP_W := 21
const MAP_H := 13
const ORIGIN := Vector2(90, 68)
const SAVE_VERSION := 1

enum Screen { MENU, WORLD, INVENTORY, HELP, DEAD, COMPLETE }

var screen: Screen = Screen.MENU
var player := Vector2i(3, 8)
var player_hp := 30
var player_max_hp := 30
var stamina := 8
var max_stamina := 8
var coins := 0
var potions := 1
var bandages := 0
var weapon_name := "Worn blade"
var weapon_bonus := 0
var armor_name := "Traveler's coat"
var armor_defense := 1
var experience := 0
var level := 1
var skill_points := 0
var bleed_turns := 0
var turn := 0
var enemy_pos := Vector2i(13, 6)
var enemy_hp := 18
var enemy_max_hp := 18
var enemy_name := "MARSH SCAVENGER"
var enemy_power := 5
var enemy_phase := 0
var enemy_alive := true
var enemy_guard := false
var player_guard := false
var cache_open := false
var contract_accepted := false
var contract_complete := false
var contract_paid := false
var message := "The marsh is quiet. Too quiet."
var message_timer := 0.0
var combat_log: Array[String] = []
var world_seed := 7319
var explored: Dictionary = {}
var region_index := 0
var herbs := 0
var scrap := 0

const WALLS := [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(4,0), Vector2i(5,0), Vector2i(6,0), Vector2i(7,0), Vector2i(8,0), Vector2i(9,0), Vector2i(10,0), Vector2i(11,0), Vector2i(12,0), Vector2i(13,0), Vector2i(14,0), Vector2i(15,0), Vector2i(16,0), Vector2i(17,0), Vector2i(18,0), Vector2i(19,0), Vector2i(20,0), Vector2i(0,1), Vector2i(20,1), Vector2i(0,2), Vector2i(20,2), Vector2i(0,3), Vector2i(20,3), Vector2i(0,4), Vector2i(20,4), Vector2i(0,5), Vector2i(20,5), Vector2i(0,6), Vector2i(20,6), Vector2i(0,7), Vector2i(20,7), Vector2i(0,8), Vector2i(20,8), Vector2i(0,9), Vector2i(20,9), Vector2i(0,10), Vector2i(20,10), Vector2i(0,11), Vector2i(20,11), Vector2i(0,12), Vector2i(1,12), Vector2i(2,12), Vector2i(3,12), Vector2i(4,12), Vector2i(5,12), Vector2i(6,12), Vector2i(7,12), Vector2i(8,12), Vector2i(9,12), Vector2i(10,12), Vector2i(11,12), Vector2i(12,12), Vector2i(13,12), Vector2i(14,12), Vector2i(15,12), Vector2i(16,12), Vector2i(17,12), Vector2i(18,12), Vector2i(19,12), Vector2i(20,12)]

var scout_pos := Vector2i(4, 4)
var cache_pos := Vector2i(8, 9)
var exit_pos := Vector2i(2, 10)
var font: Font

func _ready() -> void:
	font = ThemeDB.fallback_font
	get_window().title = "Ashen Marches"
	queue_redraw()

func _process(delta: float) -> void:
	if message_timer > 0.0:
		message_timer -= delta
		if message_timer <= 0.0:
			queue_redraw()

func _unhandled_key_input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.pressed or event.echo:
		return
	var key := event as InputEventKey
	if screen == Screen.MENU:
		if key.keycode == KEY_ENTER or key.keycode == KEY_SPACE:
			_new_game()
		elif key.keycode == KEY_F9:
			_load_game()
		return
	if screen == Screen.DEAD or screen == Screen.COMPLETE:
		if key.keycode == KEY_ENTER:
			_new_game()
		elif key.keycode == KEY_ESCAPE:
			screen = Screen.MENU
		queue_redraw()
		return
	if key.keycode == KEY_ESCAPE:
		if screen == Screen.INVENTORY or screen == Screen.HELP:
			screen = Screen.WORLD
		else:
			screen = Screen.MENU
		queue_redraw()
		return
	if screen == Screen.INVENTORY:
		if key.keycode == KEY_I:
			screen = Screen.WORLD
		elif key.keycode == KEY_H:
			_use_potion()
		elif key.keycode == KEY_B:
			_use_bandage()
		queue_redraw()
		return
	if screen == Screen.HELP:
		screen = Screen.WORLD
		queue_redraw()
		return
	match key.keycode:
		KEY_W, KEY_UP: _move(Vector2i.UP)
		KEY_S, KEY_DOWN: _move(Vector2i.DOWN)
		KEY_A, KEY_LEFT: _move(Vector2i.LEFT)
		KEY_D, KEY_RIGHT: _move(Vector2i.RIGHT)
		KEY_SPACE: _attack()
		KEY_G: _guard()
		KEY_E: _interact()
		KEY_I:
			screen = Screen.INVENTORY
			message = "Pack contents"
		KEY_H: _use_potion()
		KEY_B: _use_bandage()
		KEY_V: _heavy_attack()
		KEY_T: _trade()
		KEY_C: _craft()
		KEY_F5: _save_game()
		KEY_F9: _load_game()
		KEY_F1: screen = Screen.HELP
	queue_redraw()

func _new_game() -> void:
	screen = Screen.WORLD
	player = Vector2i(3, 8)
	region_index = 0
	herbs = 0
	scrap = 0
	player_hp = player_max_hp
	stamina = max_stamina
	coins = 0
	potions = 1
	bandages = 0
	weapon_name = "Worn blade"
	weapon_bonus = 0
	armor_name = "Traveler's coat"
	armor_defense = 1
	experience = 0
	level = 1
	skill_points = 0
	bleed_turns = 0
	turn = 0
	enemy_pos = Vector2i(13, 6)
	enemy_hp = 18
	enemy_max_hp = 18
	enemy_name = "MARSH SCAVENGER"
	enemy_power = 5
	enemy_phase = 0
	enemy_alive = true
	enemy_guard = false
	player_guard = false
	cache_open = false
	contract_accepted = false
	contract_complete = false
	contract_paid = false
	explored.clear()
	_mark_seen()
	_log("You arrive at the Greyfen watchpost.")
	_set_message("Find the scout. Something prowls in the eastern marsh.")

func _move(direction: Vector2i) -> void:
	var target := player + direction
	if _blocked(target):
		_set_message("The old stonework blocks your way.")
		return
	if enemy_alive and target == enemy_pos:
		_attack()
		return
	player = target
	_mark_seen()
	_advance_turn()
	if player == exit_pos and contract_paid:
		screen = Screen.COMPLETE
		_set_message("The road west is open. Greyfen remembers your name.")

func _blocked(cell: Vector2i) -> bool:
	if cell.x < 1 or cell.x >= MAP_W - 1 or cell.y < 1 or cell.y >= MAP_H - 1:
		return true
	if cell in [Vector2i(6,2), Vector2i(7,2), Vector2i(8,2), Vector2i(15,3), Vector2i(15,4), Vector2i(5,10), Vector2i(6,10), Vector2i(17,9), Vector2i(17,10)]:
		return true
	return false

func _mark_seen() -> void:
	for y in range(maxi(1, player.y - 3), mini(MAP_H - 1, player.y + 4)):
		for x in range(maxi(1, player.x - 4), mini(MAP_W - 1, player.x + 5)):
			explored[Vector2i(x, y)] = true

func _advance_turn() -> void:
	turn += 1
	if enemy_alive:
		var distance := absi(enemy_pos.x - player.x) + absi(enemy_pos.y - player.y)
		if distance <= 1:
			if CombatRules.hit_chance(0.88):
				var damage := CombatRules.enemy_damage(enemy_power, player_guard, armor_defense)
				player_hp -= damage
				_log("%s hits you for %d." % [enemy_name.capitalize(), damage])
				if enemy_power >= 7 and randf() < 0.28:
					bleed_turns = maxi(bleed_turns, 3)
					_log("The wound starts bleeding.")
			else:
				_log("The scavenger misses.")
			if player_hp <= 0:
				player_hp = 0
				screen = Screen.DEAD
				_log("You collapse in the reeds.")
		elif distance <= 7:
			var step := Vector2i(signi(player.x - enemy_pos.x), signi(player.y - enemy_pos.y))
			var candidate := enemy_pos + step
			if not _blocked(candidate) and candidate != player and candidate != scout_pos and candidate != cache_pos:
				enemy_pos = candidate
	if bleed_turns > 0 and player_hp > 0:
		player_hp = maxi(0, player_hp - 1)
		bleed_turns -= 1
		_log("Bleeding: -1 health.")
		if player_hp <= 0:
			screen = Screen.DEAD
			_log("You succumb to your wounds.")
	player_guard = false
	stamina = mini(max_stamina, stamina + 1)

func _attack() -> void:
	if not enemy_alive:
		_set_message("There is nothing left to fight.")
		return
	var distance := absi(enemy_pos.x - player.x) + absi(enemy_pos.y - player.y)
	if distance > 1:
		_set_message("Move adjacent to strike.")
		return
	if stamina < 2:
		_set_message("Too exhausted. Guard or wait to recover.")
		return
	stamina -= 2
	if CombatRules.hit_chance(0.9):
		var damage := CombatRules.player_damage(7 + weapon_bonus, enemy_guard)
		enemy_hp -= damage
		_log("You strike the scavenger for %d." % damage)
	else:
		_log("Your strike cuts only mist.")
	if enemy_hp <= 0:
		_resolve_enemy_defeat()
	_advance_turn()

func _heavy_attack() -> void:
	if not enemy_alive:
		_set_message("There is nothing left to strike.")
		return
	var distance := absi(enemy_pos.x - player.x) + absi(enemy_pos.y - player.y)
	if distance > 1:
		_set_message("Move adjacent to strike.")
		return
	if stamina < 4:
		_set_message("A heavy strike requires 4 stamina.")
		return
	stamina -= 4
	var damage := CombatRules.player_damage(12 + weapon_bonus, enemy_guard)
	enemy_hp -= damage
	_log("Heavy strike deals %d damage." % damage)
	if enemy_hp <= 0:
		_resolve_enemy_defeat()
	_advance_turn()

func _check_level_up() -> void:
	var threshold := level * 50
	while experience >= threshold:
		experience -= threshold
		level += 1
		skill_points += 1
		player_max_hp += 4
		max_stamina += 1
		player_hp = mini(player_max_hp, player_hp + 4)
		stamina = max_stamina
		_log("LEVEL UP! You are now level %d." % level)
		threshold = level * 50

func _use_bandage() -> void:
	if bandages <= 0:
		_set_message("No bandages remain.")
		return
	if bleed_turns <= 0 and player_hp >= player_max_hp:
		_set_message("You have no wounds to dress.")
		return
	bandages -= 1
	bleed_turns = 0
	var healed := mini(5, player_max_hp - player_hp)
	player_hp += healed
	_log("You dress your wounds and recover %d health." % healed)
	_advance_turn()

func _guard() -> void:
	player_guard = true
	stamina = mini(max_stamina, stamina + 3)
	_set_message("You brace behind your weapon. Stamina restored.")
	_advance_turn()

func _use_potion() -> void:
	if potions <= 0:
		_set_message("No healing draughts remain.")
		return
	if player_hp >= player_max_hp:
		_set_message("You are already in good health.")
		return
	potions -= 1
	var healed := mini(12, player_max_hp - player_hp)
	player_hp += healed
	_log("You drink a draught and recover %d health." % healed)
	_advance_turn()

func _interact() -> void:
	var nearby := _nearest_landmark()
	match nearby:
		"scout":
			if not contract_accepted:
				contract_accepted = true
				_set_message("Scout: Kill the marsh scavenger to the east. 20 crowns await.")
				_log("Contract accepted: The Thing in the Reeds.")
			elif contract_complete and not contract_paid:
				contract_paid = true
				coins += 20
				_set_message("Scout: Good work. Take your 20 crowns.")
				_log("Contract completed. Reward: 20 crowns.")
			elif contract_paid:
				_set_message("Scout: The road west is clear. Good luck.")
			else:
				_set_message("Scout: The scavenger is still out there. East of the cache.")
		"cache":
			if cache_open:
				_set_message("The supply chest is empty.")
			else:
				cache_open = true
				coins += 4
				potions += 1
				bandages += 2
				herbs += 2
				scrap += 2
				weapon_name = "Fen-forged sword"
				weapon_bonus = 2
				armor_name = "Marshguard coat"
				armor_defense = 3
				_set_message("You find a Fen-forged sword, Marshguard coat, draught and bandages.")
				_log("Cache: upgraded weapon and armor, +1 draught, +2 bandages.")
			_advance_turn()
		"exit":
			if contract_paid:
				_advance_region()
			else:
				_set_message("The western road is barred until the scout's contract is settled.")
		_:
			_set_message("Nothing nearby answers your call.")

func _nearest_landmark() -> String:
	var options := {"scout": scout_pos, "cache": cache_pos, "exit": exit_pos}
	var best := ""
	var best_distance := 99
	for key in options:
		var pos: Vector2i = options[key]
		var d := absi(pos.x - player.x) + absi(pos.y - player.y)
		if d <= 1 and d < best_distance:
			best = key
			best_distance = d
	return best


func _region_name() -> String:
	match region_index:
		0: return "GREYFEN MARSH"
		1: return "THE DROWNED ROAD"
		_: return "OLD IRONROOT MINE"

func _region_second_enemy() -> String:
	match region_index:
		0: return "MIRE STALKER"
		1: return "CISTERN BRUTE"
		_: return "HOLLOW REVENANT"

func _region_second_hp() -> int:
	return [26, 31, 38][region_index]

func _region_second_power() -> int:
	return [7, 8, 10][region_index]

func _advance_region() -> void:
	if region_index >= 2:
		screen = Screen.COMPLETE
		_set_message("The western road is open. Three blighted reaches lie behind you.")
		return
	region_index += 1
	player = Vector2i(3, 8)
	enemy_phase = 0
	enemy_alive = true
	enemy_guard = false
	player_guard = false
	cache_open = false
	contract_accepted = false
	contract_complete = false
	contract_paid = false
	enemy_pos = Vector2i(14, 6)
	match region_index:
		1:
			enemy_name = "ROAD WIGHT"
			enemy_hp = 23
			enemy_max_hp = 23
			enemy_power = 6
		2:
			enemy_name = "ASHEN KNIGHT"
			enemy_hp = 29
			enemy_max_hp = 29
			enemy_power = 8
	_mark_seen()
	_log("Expedition enters %s." % _region_name().capitalize())
	_set_message("New frontier: %s. Find its scout and prepare for the hunt." % _region_name().capitalize())

func _trade() -> void:
	if _nearest_landmark() != "scout":
		_set_message("Trade only with the quartermaster beside the scout.")
		return
	if coins >= 8:
		coins -= 8
		potions += 1
		_set_message("Quartermaster: one healing draught. Eight crowns.")
	elif coins >= 6:
		coins -= 6
		bandages += 2
		_set_message("Quartermaster: two bandages. Six crowns.")
	else:
		_set_message("A draught costs 8 crowns; two bandages cost 6.")

func _craft() -> void:
	if herbs >= 2 and scrap >= 1:
		herbs -= 2
		scrap -= 1
		potions += 1
		_set_message("You brew a field draught from marsh herbs and scrap.")
	elif herbs >= 1 and scrap >= 1:
		herbs -= 1
		scrap -= 1
		bandages += 1
		_set_message("You bind a fresh bandage from gathered materials.")
	else:
		_set_message("Crafting needs herbs and scrap. Search each region's supply cache.")

func _save_game() -> void:
	var data := {
		"player": [player.x, player.y], "hp": player_hp, "stamina": stamina,
		"coins": coins, "potions": potions, "bandages": bandages, "turn": turn,
		"player_max_hp": player_max_hp, "max_stamina": max_stamina,
		"weapon_name": weapon_name, "weapon_bonus": weapon_bonus, "armor_name": armor_name, "armor_defense": armor_defense,
		"experience": experience, "level": level, "skill_points": skill_points, "bleed_turns": bleed_turns, "enemy_phase": enemy_phase,
		"enemy_name": enemy_name, "enemy_max_hp": enemy_max_hp, "enemy_power": enemy_power,
		"enemy_pos": [enemy_pos.x, enemy_pos.y], "enemy_hp": enemy_hp,
		"enemy_alive": enemy_alive, "cache_open": cache_open,
		"contract_accepted": contract_accepted, "contract_complete": contract_complete,
		"contract_paid": contract_paid, "region_index": region_index,
		"herbs": herbs, "scrap": scrap, "explored": explored
	}
	if SaveSystem.write(data):
		_set_message("Game saved.")
	else:
		_set_message("Save failed. Check available disk space.")

func _load_game() -> void:
	var data := SaveSystem.read()
	if data.is_empty():
		_set_message("No compatible save found.")
		return
	var p: Array = data.get("player", [3, 8])
	var e: Array = data.get("enemy_pos", [13, 6])
	player = Vector2i(int(p[0]), int(p[1]))
	enemy_pos = Vector2i(int(e[0]), int(e[1]))
	player_max_hp = maxi(30, int(data.get("player_max_hp", 30)))
	max_stamina = maxi(8, int(data.get("max_stamina", 8)))
	player_hp = clampi(int(data.get("hp", 30)), 0, player_max_hp)
	stamina = clampi(int(data.get("stamina", 8)), 0, max_stamina)
	coins = int(data.get("coins", 0))
	potions = int(data.get("potions", 0))
	bandages = int(data.get("bandages", 0))
	weapon_name = str(data.get("weapon_name", "Worn blade"))
	weapon_bonus = int(data.get("weapon_bonus", 0))
	armor_name = str(data.get("armor_name", "Traveler's coat"))
	armor_defense = int(data.get("armor_defense", 1))
	experience = int(data.get("experience", 0))
	level = int(data.get("level", 1))
	skill_points = int(data.get("skill_points", 0))
	bleed_turns = int(data.get("bleed_turns", 0))
	enemy_phase = int(data.get("enemy_phase", 0))
	enemy_name = str(data.get("enemy_name", "MARSH SCAVENGER"))
	enemy_max_hp = int(data.get("enemy_max_hp", 18))
	enemy_power = int(data.get("enemy_power", 5))
	turn = int(data.get("turn", 0))
	enemy_hp = int(data.get("enemy_hp", 18))
	enemy_alive = bool(data.get("enemy_alive", true))
	cache_open = bool(data.get("cache_open", false))
	contract_accepted = bool(data.get("contract_accepted", false))
	contract_complete = bool(data.get("contract_complete", false))
	contract_paid = bool(data.get("contract_paid", false))
	region_index = clampi(int(data.get("region_index", 0)), 0, 2)
	herbs = maxi(0, int(data.get("herbs", 0)))
	scrap = maxi(0, int(data.get("scrap", 0)))
	var saved_explored: Variant = data.get("explored", {})
	explored = saved_explored if saved_explored is Dictionary else {}
	screen = Screen.WORLD
	_mark_seen()
	_set_message("Expedition restored.")

func _log(line: String) -> void:
	combat_log.push_front(line)
	while combat_log.size() > 4:
		combat_log.pop_back()

func _set_message(value: String) -> void:
	message = value
	message_timer = 5.0
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(1280, 720)), Color("#111916"))
	if screen == Screen.MENU:
		_draw_menu()
		return
	_draw_world()
	_draw_hud()
	if screen == Screen.INVENTORY:
		_draw_inventory()
	elif screen == Screen.HELP:
		_draw_help()
	elif screen == Screen.DEAD:
		_draw_overlay("YOU HAVE FALLEN", "The marsh takes another wanderer.", "Press ENTER to begin again  •  ESC for menu")
	elif screen == Screen.COMPLETE:
		_draw_overlay("THE ROAD WEST", "Contract settled. Greyfen is safe — for now.", "Press ENTER for a new expedition  •  ESC for menu")

func _draw_menu() -> void:
	draw_rect(Rect2(0, 0, 1280, 720), Color("#111916"))
	for i in range(36):
		var x := float((i * 173) % 1280)
		var y := float((i * 97) % 720)
		draw_circle(Vector2(x, y), 1.5, Color("#52634e"))
	draw_rect(Rect2(150, 100, 980, 520), Color("#1d2924"), true)
	draw_rect(Rect2(150, 100, 980, 520), Color("#69765b"), false, 2)
	_text("ASHEN MARCHES", Vector2(245, 235), 54, Color("#d7c99e"))
	_text("A GREYFEN EXPEDITION", Vector2(250, 280), 19, Color("#8fa18a"))
	draw_line(Vector2(250, 310), Vector2(1030, 310), Color("#59674f"), 2)
	_text("The old road has swallowed its last patrol.", Vector2(250, 365), 23, Color("#c3c0a9"))
	_text("Something moves beneath the drowned reeds.", Vector2(250, 400), 23, Color("#c3c0a9"))
	_text("[ ENTER ]  Begin expedition", Vector2(250, 485), 22, Color("#e3d6a9"))
	_text("[ F9 ]  Load saved expedition", Vector2(250, 525), 18, Color("#9aaa8c"))
	_text("GODOT 4  •  TURN-BASED DARK FANTASY", Vector2(250, 580), 14, Color("#718171"))

func _draw_world() -> void:
	for y in range(1, MAP_H - 1):
		for x in range(1, MAP_W - 1):
			var cell := Vector2i(x, y)
			var rect := Rect2(ORIGIN + Vector2(x * TILE, y * TILE), Vector2(TILE - 2, TILE - 2))
			var base := Color("#34483a") if (x + y) % 3 else Color("#3b4b3b")
			if (x * 7 + y * 11) % 9 == 0:
				base = Color("#293f3c")
			if cell in [Vector2i(6,2), Vector2i(7,2), Vector2i(8,2), Vector2i(15,3), Vector2i(15,4), Vector2i(5,10), Vector2i(6,10), Vector2i(17,9), Vector2i(17,10)]:
				base = Color("#26312b")
			draw_rect(rect, base)
			if (x * 13 + y * 5) % 7 == 0:
				draw_circle(rect.position + Vector2(12, 14), 2, Color("#60715a"))
			if cell not in explored and (abs(x - player.x) > 5 or abs(y - player.y) > 4):
				draw_rect(rect, Color(0.035, 0.055, 0.05, 0.78))
	_draw_landmark(scout_pos, Color("#c2ad79"), "S")
	_draw_landmark(cache_pos, Color("#b58b55") if not cache_open else Color("#635943"), "C")
	_draw_landmark(exit_pos, Color("#8caa91"), "W")
	if enemy_alive:
		_draw_actor(enemy_pos, Color("#a95e49"), "!")
		_text("%s  %d/%d" % [enemy_name, enemy_hp, enemy_max_hp], _screen_pos(enemy_pos) + Vector2(-24, -12), 11, Color("#f0c5a8"))
	_draw_actor(player, Color("#d4c99b"), "@")
	_text("%s  •  TURN %d" % [_region_name(), turn], Vector2(ORIGIN.x, 48), 16, Color("#b9c6aa"))

func _draw_landmark(pos: Vector2i, color: Color, glyph: String) -> void:
	var center := _screen_pos(pos) + Vector2(TILE / 2.0 - 1, TILE / 2.0 - 1)
	draw_rect(Rect2(center - Vector2(13, 13), Vector2(26, 26)), color)
	_text(glyph, center + Vector2(-6, 6), 17, Color("#202820"))

func _draw_actor(pos: Vector2i, color: Color, glyph: String) -> void:
	var center := _screen_pos(pos) + Vector2(TILE / 2.0 - 1, TILE / 2.0 - 1)
	draw_circle(center + Vector2(0, 3), 17, Color(0, 0, 0, 0.35))
	draw_circle(center, 15, color)
	draw_circle(center + Vector2(-4, -4), 4, Color("#eee5c9"))
	_text(glyph, center + Vector2(-6, 7), 17, Color("#242923"))

func _draw_hud() -> void:
	draw_rect(Rect2(0, 690, 1280, 30), Color("#17211d"))
	draw_rect(Rect2(1010, 58, 240, 580), Color("#1b2822"))
	draw_rect(Rect2(1010, 58, 240, 580), Color("#5d6c58"), false, 2)
	_text("WANDERER", Vector2(1030, 90), 17, Color("#d6c99e"))
	_text("HEALTH", Vector2(1030, 126), 13, Color("#b9b9a1"))
	draw_rect(Rect2(1030, 138, 195, 12), Color("#3b3931"))
	draw_rect(Rect2(1030, 138, 195.0 * player_hp / player_max_hp, 12), Color("#a65e4b"))
	_text("%d / %d" % [player_hp, player_max_hp], Vector2(1030, 169), 14, Color("#e2d8c2"))
	_text("STAMINA", Vector2(1030, 201), 13, Color("#b9b9a1"))
	draw_rect(Rect2(1030, 213, 195, 10), Color("#343c35"))
	draw_rect(Rect2(1030, 213, 195.0 * stamina / max_stamina, 10), Color("#b99b55"))
	_text("CROWNS  %d" % coins, Vector2(1030, 252), 16, Color("#d5c48d"))
	_text("DRAUGHTS  %d" % potions, Vector2(1030, 281), 16, Color("#a9c7aa"))
	_text("BANDAGES  %d" % bandages, Vector2(1030, 305), 13, Color("#a9c7aa"))
	_text("HERBS %d  SCRAP %d" % [herbs, scrap], Vector2(1030, 345), 12, Color("#a9c7aa"))
	_text("LEVEL %d  XP %d" % [level, experience], Vector2(1030, 328), 13, Color("#d5c48d"))
	draw_line(Vector2(1030, 300), Vector2(1230, 300), Color("#52614f"), 1)
	_text("CONTRACT", Vector2(1030, 360), 15, Color("#d6c99e"))
	var quest := "Find the scout" if not contract_accepted else ("Return to scout" if contract_complete and not contract_paid else ("Settled" if contract_paid else "Slay the scavenger"))
	_text(quest, Vector2(1030, 388), 14, Color("#b8c5ae"))
	_text("FIELD NOTES", Vector2(1030, 430), 14, Color("#d6c99e"))
	for i in range(combat_log.size()):
		_text(combat_log[i], Vector2(1030, 458 + i * 27), 11, Color("#aab5a3"))
	draw_rect(Rect2(24, 620, 950, 54), Color("#18241f"))
	draw_rect(Rect2(24, 620, 950, 54), Color("#52614f"), false, 1)
	_text(message, Vector2(42, 653), 15, Color("#e1d7b7"))
	_text("WASD MOVE • SPACE STRIKE • V HEAVY • G GUARD • E USE • I PACK • H HEAL • B BANDAGE • F5 SAVE", Vector2(24, 711), 12, Color("#9ba995"))

func _draw_inventory() -> void:
	draw_rect(Rect2(300, 170, 650, 390), Color("#1b2822"))
	draw_rect(Rect2(300, 170, 650, 390), Color("#a18f65"), false, 2)
	_text("TRAVELER'S PACK", Vector2(345, 225), 28, Color("#d7c99e"))
	_text("Healing draughts     x%d" % potions, Vector2(350, 280), 20, Color("#a9c7aa"))
	_text("Bandages             x%d" % bandages, Vector2(350, 315), 20, Color("#a9c7aa"))
	_text("Weapon: %s  (+%d damage)" % [weapon_name, weapon_bonus], Vector2(350, 355), 18, Color("#d5c48d"))
	_text("Armor: %s  (%d defense)" % [armor_name, armor_defense], Vector2(350, 390), 18, Color("#a9c7aa"))
	_text("Level %d  •  XP %d / %d  •  Skill points %d" % [level, experience, level * 50, skill_points], Vector2(350, 430), 17, Color("#d7c99e"))
	_text("Bleeding: %d turns" % bleed_turns, Vector2(350, 465), 16, Color("#c47c68"))
	_text("Crowns               %d" % coins, Vector2(350, 340), 20, Color("#d5c48d"))
	_text("Herbs %d  •  Scrap %d" % [herbs, scrap], Vector2(350, 410), 18, Color("#a9c7aa"))
	_text("H: draught  •  B: bandage  •  I / ESC: close", Vector2(350, 520), 16, Color("#9ba995"))

func _draw_help() -> void:
	draw_rect(Rect2(270, 130, 740, 470), Color("#1b2822"))
	draw_rect(Rect2(270, 130, 740, 470), Color("#a18f65"), false, 2)
	_text("FIELD MANUAL", Vector2(320, 190), 30, Color("#d7c99e"))
	var lines := ["Move one tile at a time. Every action gives nearby enemies a turn.",
		"SPACE attacks an adjacent foe. Attacks cost 2 stamina.",
		"G guards and restores stamina; H heals, B dresses bleeding wounds.",
		"V performs a heavy strike for 4 stamina. Armor reduces incoming damage.",
		"Find the cache for improved armor and a stronger blade. Defeat both creatures.",
		"E interacts with the scout, cache, and western road.",
		"Accept the scout's contract, defeat the scavenger, then return.",
		"F5 saves locally. F9 loads. I opens your pack.",
		"ESC closes this page. F1 opens this manual."]
	for i in range(lines.size()):
		_text(lines[i], Vector2(320, 255 + i * 38), 16, Color("#c3c0a9"))
	_text("Press any key to return", Vector2(320, 550), 15, Color("#a9b99c"))

func _draw_overlay(title: String, subtitle: String, footer: String) -> void:
	draw_rect(Rect2(220, 210, 840, 300), Color("#18231f"))
	draw_rect(Rect2(220, 210, 840, 300), Color("#b29a69"), false, 2)
	_text(title, Vector2(300, 300), 38, Color("#d7c99e"))
	_text(subtitle, Vector2(300, 360), 19, Color("#c3c0a9"))
	_text(footer, Vector2(300, 445), 16, Color("#9eae98"))

func _screen_pos(cell: Vector2i) -> Vector2:
	return ORIGIN + Vector2(cell.x * TILE, cell.y * TILE)

func _text(value: String, position: Vector2, size: int, color: Color) -> void:
	draw_string(font, position, value, HORIZONTAL_ALIGNMENT_LEFT, -1, size, color)
