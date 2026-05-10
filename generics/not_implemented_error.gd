class_name NotImplementedError

const _NEWLINE_INDENT: String = "    "


class StackFrame:
	var global_file_path: String
	var file_path: String
	var file_name: String
	var file_stem: String
	var line_number: String
	var function_name: String

	var short_caller: String:
		get:
			return "%s.%s: line %s" % [file_stem, function_name, line_number]

	func _init(frame_dict: Dictionary) -> void:
		file_path = frame_dict.get("source", "unknown")
		file_name = file_path.get_file()
		file_stem = file_name.get_basename()
		line_number = str(frame_dict.get("line", "unknown"))
		function_name = frame_dict.get("function", "unknown")

		if file_path != "unknown":
			global_file_path = PathUtility.get_full_system_path(file_path)
		else:
			global_file_path = "unknown"

	func _to_string() -> String:
		return "at %s.%s: line %s in %s" % [file_stem, function_name, line_number, global_file_path]


func _init(message: String = "") -> void:
	var stack: Array = get_stack().slice(1).map(func(frame_dict): return StackFrame.new(frame_dict))

	var header := "%s: %s" % [get_script().get_global_name(), message]
	var message_parts: Array[String] = [header]

	for frame in stack:
		message_parts.append(str(frame))

	var full_message: String = ("\n" + _NEWLINE_INDENT).join(message_parts)

	push_error(full_message)
