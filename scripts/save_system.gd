extends RefCounted
class_name SaveSystem

const SAVE_PATH := "user://ashen_marches.save"
const SAVE_VERSION := 3

static func write(data: Dictionary) -> bool:
	var config := ConfigFile.new()
	config.set_value("meta", "version", SAVE_VERSION)
	config.set_value("run", "data", data)
	return config.save(SAVE_PATH) == OK

static func read() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(SAVE_PATH) != OK:
		return {}
	var version := int(config.get_value("meta", "version", 0))
	if version < 1 or version > SAVE_VERSION:
		return {}
	var data: Variant = config.get_value("run", "data", {})
	return data if data is Dictionary else {}
