extends ReusableSaveSystem.Reader


var _file_path: StringName
var _json: JSON


func _init(file_path: StringName) -> void:
	_file_path = file_path
	_json = JSON.new()


func read() -> void:
	var data = _read_data_or_null()
	if data:
		data_read.emit(data)
	else:
		no_data_found.emit()


func _read_data_or_null() -> Variant:
	if not FileAccess.file_exists(_file_path):
		return

	var contents := FileAccess.get_file_as_string(_file_path)

	var error := _json.parse(contents)

	if error != OK:
		_log_error()
		return

	return _json.data


## Logs the error in _json
func _log_error() -> void:
	push_warning(" ".join([
		"Error parsing JSON save at \"%s\"." % _file_path,
		"%s on line %s." % [_json.get_error_message(), _json.get_error_line()]
	]))


func _to_string() -> String:
	var error_message := _json.get_error_message()
	if error_message.is_empty():
		error_message = "OK"
	else:
		error_message = "\"" + error_message + "\""
	return "json_file_reader<\"%s\", error=%s>" % [_file_path, error_message]
