extends RefCounted
class_name CombatRules

static func player_damage(power: int, guarding: bool) -> int:
	return maxi(1, power + randi_range(-1, 2))

static func enemy_damage(power: int, guarded: bool, armor: int = 0) -> int:
	var raw := power + randi_range(-1, 1)
	return maxi(1, raw - (2 if guarded else 0) - armor)

static func hit_chance(accuracy: float = 0.9) -> bool:
	return randf() <= accuracy
