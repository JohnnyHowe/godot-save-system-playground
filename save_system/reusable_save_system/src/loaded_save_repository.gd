## Holds the loaded saves and selection.
## For interal save system use only.
const NO_SELECTION_MADE: int = -1


var selected_save: Variant:
	get: return _get_selected_save()
	set(value): _set_selected_save(value)

var selected_save_index: int:
	get: return _selected_save_index
	set(value): _set_selected_save_index(value)

var _selected_save_index: int = NO_SELECTION_MADE
var _loaded_saves: Array = []


func add_save(save_data: Variant) -> void:
	print("repo add save!")
	if _loaded_saves.has(save_data):
		push_error("Cannot add save! Repository already holding this one")
		return
	_loaded_saves.append(save_data)


func _get_selected_save() -> Variant:
	var error := _get_selected_save_error_string()
	if not error.is_empty():
		push_error(error)
		return null
	return _loaded_saves[selected_save_index]


func _set_selected_save(save_data: Variant) -> void:
	var index := _loaded_saves.find(save_data)
	if index == -1:
		push_error("Cannot set selected save. The save given has not been added!")
		return
	selected_save_index = index


func _set_selected_save_index(index: int) -> void:
	if index < 0:
		push_error("Cannot select save with negative index! Got %s" % index)
		return
	if index >= _loaded_saves.size():
		push_error("Cannot select save with index greater than number of loaded saves! Number of loaded saves: %s, index=%s" % [_loaded_saves.size(), index])
		return
	_selected_save_index = index


func is_valid_save_selected() -> bool:
	return _get_selected_save_error_string().is_empty()


func _get_selected_save_error_string() -> StringName:
	if selected_save_index == NO_SELECTION_MADE:
		return "No save selected!"
	if selected_save_index >= _loaded_saves.size():
		return "Selected save index invalid!"
	return ""
