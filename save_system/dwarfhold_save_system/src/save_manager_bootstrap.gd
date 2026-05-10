extends Node

const SaveManager := preload("./save_manager.gd")
const JsonFileWriter := preload("./current_save_version/json_file_writer.gd")
const JsonFileReader := preload("./current_save_version/json_file_reader.gd")
const DefaultDataCreator := preload("./current_save_version/default_data_creator.gd")

@export var _save_manager: SaveManager
@export var _read_paths: Array[StringName]
@export var _write_path: StringName 


var _migrators: Array[ReusableSaveSystem.Migrator] = [
	preload("./migrators/version1_to_version2_migrator.gd").new()
]

func _enter_tree() -> void:
	_inject()


func _inject() -> void:
	_save_manager.inject(_create_manager(), DefaultDataCreator.create_default)


func _create_manager() -> ReusableSaveSystem.Manager:
	return ReusableSaveSystem.Manager.new(
		_create_readers(),
		_migrators,
		JsonFileWriter.new(_write_path, "\t"),
	)

func _create_readers() -> Array[ReusableSaveSystem.Reader]:
	var readers :Array[ReusableSaveSystem.Reader] = []
	for read_path in _read_paths:
		readers.append(JsonFileReader.new(read_path))
	return readers
