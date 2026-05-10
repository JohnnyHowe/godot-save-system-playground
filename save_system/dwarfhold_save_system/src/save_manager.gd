extends Node


var JsonFileReader := preload("./json_file_reader.gd")

var _readers: Array[ReusableSaveSystem.Reader] = [
	JsonFileReader.new("saves/main_save_v1.json"),
	JsonFileReader.new("saves/main_save_v1.json"),
]

var _migrators: Array[ReusableSaveSystem.Migrator] = []

var _load_manager: ReusableSaveSystem.LoadManager


func _ready() -> void:

	_load_manager = ReusableSaveSystem.LoadManager.new(
		_readers, 
		ReusableSaveSystem.MigrationPipeline.new(_migrators)
	)

	_load_manager.data_loaded_value.connect(_on_data_loaded)
	_load_manager.load_all()


func _on_data_loaded(data: Variant) -> void:
	print(data)
