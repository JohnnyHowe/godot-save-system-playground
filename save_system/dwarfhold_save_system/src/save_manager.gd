extends Node

const KeyValidator := preload("./key_validator.gd")

var _manager: ReusableSaveSystem.Manager
var _create_default_data: Callable

var current_save: Variant:
	get: return _manager.selection.selected_save
	set(value): _manager.add_and_select(value)


func inject(manager: ReusableSaveSystem.Manager, create_default_data: Callable) -> void:
	_create_default_data = create_default_data
	_manager = manager
	_manager.all_readers_responded.connect(_pick_first_save_or_create_new_if_none_set)
	_manager.load()


func _pick_first_save_or_create_new_if_none_set() -> void:
	if not _manager.selection.is_selection_valid():
		_pick_first_save_or_create_new()


func _pick_first_save_or_create_new() -> void:
	if _manager.saves.size() == 0:
		_manager.add_and_select(_create_default_data.call())
	else:
		_manager.selection.selected_save_index = 0

	print("Save loaded!")
	print(current_save)

	save()


func save() -> void:
	_manager.save()
