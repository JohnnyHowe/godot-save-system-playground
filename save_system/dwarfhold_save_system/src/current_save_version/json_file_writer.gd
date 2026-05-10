extends ReusableSaveSystem.Writer


var _file_name: StringName
var _indent: String


func _init(file_name: StringName, indent: String = "") -> void:
	_file_name = file_name
	_indent = indent


func write(save_data: Variant) -> void:
	var serialized_data := JSON.stringify(save_data, _indent)
	_write_string(serialized_data)


func _write_string(content: String) -> void:
	var file = FileAccess.open(_file_name, FileAccess.WRITE)
	file.store_string(content)
