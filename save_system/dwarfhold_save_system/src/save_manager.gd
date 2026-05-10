extends Node

var JsonFileReader := preload("./json_file_reader.gd")

var _load_manager: ReusableSaveSystem.LoadManager

var _readers: Array[ReusableSaveSystem.Reader] = [
	JsonFileReader.new("saves/main_save_v1.json")
]

var _migrators: Array[ReusableSaveSystem.Migrator] = []


func _ready() -> void:
	_load_manager = ReusableSaveSystem.LoadManager.new(_readers, _migrators)
	_load_manager.load_all()
