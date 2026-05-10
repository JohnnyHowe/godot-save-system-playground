extends Node

const Validator := preload("./validator.gd")


var JsonFileReader := preload("./json_file_reader.gd")

var _readers: Array[ReusableSaveSystem.Reader] = [
	JsonFileReader.new("saves/main_save_v1_stripped.json"),
]

var _migrators: Array[ReusableSaveSystem.Migrator] = [
	preload("./migrators/version1_to_version2_migrator.gd").new()
]

var _load_manager: ReusableSaveSystem.LoadManager


func _ready() -> void:
	_load_manager = ReusableSaveSystem.LoadManager.new(
		_readers,
		ReusableSaveSystem.MigrationPipeline.new(_migrators)
	)

	_load_manager.data_loaded_value.connect(_on_data_loaded)
	_load_manager.load_all()


func _on_data_loaded(data: Variant) -> void:
	print("SaveManager recieved data!")

	print(JSON.stringify(data, "\t"))

	var validation_error := Validator.get_validation_error(data)
	if not validation_error.is_empty():
		push_error("Loaded data failed validation! %s" % validation_error)
		return
	
	print("SaveManager recieved valid data!")
	# print(JSON.stringify(_data, "\t"))

	get_tree().quit.call_deferred()
