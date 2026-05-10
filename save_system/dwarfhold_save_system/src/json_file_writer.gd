extends ReusableSaveSystem.Writer


var _file_name: StringName


func _init(file_name: StringName) -> void:
	_file_name = file_name


func write(save_data: Variant) -> void:
	pass
