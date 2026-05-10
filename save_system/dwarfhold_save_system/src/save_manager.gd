extends Node

const KeyValidator := preload("./key_validator.gd")

var _manager: ReusableSaveSystem.Manager

var current_save: Variant:
	get: return _manager.selection.selected_save
	set(value): _manager.add_and_select(value)


func set_manager(manager: ReusableSaveSystem.Manager) -> void:
	_manager = manager
	_manager.all_readers_responded.connect(_pick_first_save_or_create_new_if_none_set)
	_manager.load()


func _pick_first_save_or_create_new_if_none_set() -> void:
	if not _manager.selection.is_valid_save_selected():
		_pick_first_save_or_create_new()


func _pick_first_save_or_create_new() -> void:
	print(_manager.saves)
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
