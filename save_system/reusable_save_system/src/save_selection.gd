## Holds the save selection.
## For interal save system use only.
const NO_SELECTION_MADE: int = -1


var selected_save: Variant:
	get: return _get_selected_save()
	set(value): _set_selected_save(value)

var selected_save_index: int:
	get: return _selected_save_index
	set(value): _set_selected_save_index(value)

var _selected_save_index: int = NO_SELECTION_MADE
var _saves: Array


func _init(saves_reference: Array) -> void:
	_saves = saves_reference


func clear() -> void:
	_selected_save_index = NO_SELECTION_MADE


func is_selection_valid() -> bool:
	return _get_selected_save_error_string().is_empty()


func _get_selected_save() -> Variant:
	var index := _get_selected_save_index_with_error()
	if index == NO_SELECTION_MADE:
		return null
	return _saves[selected_save_index]


func _set_selected_save(save_data: Variant) -> void:
	var index := _saves.find(save_data)
	if index == -1:
		push_error("Cannot set save selection. It does not exist in repository!")
		return
	selected_save_index = index


func _set_selected_save_index(index: int) -> void:
	if index < 0:
		push_error("Cannot select save with negative index! Got %s" % index)
		return
	if index >= _saves.size():
		push_error("Cannot select save with index greater than number of loaded saves! Number of loaded saves: %s, index=%s" % [_saves.size(), index])
		return
	_selected_save_index = index


func _get_selected_save_index_with_error() -> int:
	var selected_save_error_string := _get_selected_save_error_string()
	if not selected_save_error_string.is_empty():
		push_error(selected_save_error_string)
		return NO_SELECTION_MADE
	return selected_save_index


func _get_selected_save_error_string() -> StringName:
	if selected_save_index == NO_SELECTION_MADE:
		return "No save selected!"
	if selected_save_index >= _saves.size():
		return "Selected save index invalid!"
	return ""
