extends Node

const KeyValidator := preload("./key_validator.gd")
const JsonFileWriter := preload("./json_file_writer.gd")
const JsonFileReader := preload("./json_file_reader.gd")

var _readers: Array[ReusableSaveSystem.Reader] = [
	JsonFileReader.new("saves/main_save_v1_stripped.json"),
]

var _migrators: Array[ReusableSaveSystem.Migrator] = [
	preload("./migrators/version1_to_version2_migrator.gd").new()
]

var _manager: ReusableSaveSystem.Manager

var current_save: Variant:
	get: return _manager.selection.selected_save
	set(value): _manager.add_and_select(value)


func _ready() -> void:
	_create_manager()
	_manager.all_readers_responded.connect(print.bind("done!"))
	_manager.load()
	# _pick_first_save_or_create_new()


func _create_manager() -> void:
	_manager = ReusableSaveSystem.Manager.new(
		_readers,
		_migrators,
		JsonFileWriter.new("res://saves/re-written-save.json"),
	)


func _pick_first_save_or_create_new() -> void:
	if _manager.saves.size() == 0:
		_manager.add_and_select(_create_default_save())
	else:
		_manager.selection.selected_save_index = 0


func _create_default_save() -> Dictionary:
	return {
		"metadata": {
			"schema_version": 2,
			"data_validation_key": null
		},
		"data": {}
	}


func save() -> void:
	_manager.save()
