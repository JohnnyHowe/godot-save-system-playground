extends Node

const KeyValidator := preload("./key_validator.gd")
const JsonFileWriter := preload("./json_file_writer.gd")
const JsonFileReader := preload("./json_file_reader.gd")

var _readers: Array[ReusableSaveSystem.Reader] = [
	JsonFileReader.new("saves/main_save_v1_stripped.json"),
]

var _migrators: Array[ReusableSaveSystem.Migrator] = [
	preload("./migrators/version1_to_version2_migrator.gd").new()
]

var _manager: ReusableSaveSystem.Manager


func _ready() -> void:
	_create_manager()
	_manager.load()


func _create_manager() -> void:
	_manager = ReusableSaveSystem.Manager.new(
		_readers,
		_migrators,
		JsonFileWriter.new("res://saves/re-written-save.json"),
		[KeyValidator.new()] as Array[ReusableSaveSystem.Validator]
	)


func save() -> void:
	_manager.save()
