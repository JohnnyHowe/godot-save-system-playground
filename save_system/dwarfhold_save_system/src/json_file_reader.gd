extends ReusableSaveSystem.Reader


var _file_path: StringName


func _init(file_path: StringName) -> void:
	_file_path = file_path


func load() -> void:
	NotImplementedError.new()
