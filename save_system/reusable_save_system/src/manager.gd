## Facade to the whole save system.
## Allows saving and loading with backwards compatability.
## Delegates everything.

signal all_readers_responded

var selection: ReusableSaveSystem.SaveSelection

var _load_pipeline: ReusableSaveSystem.LoadPipeline
var _writer: ReusableSaveSystem.Writer

var saves: Array:
	get: return _saves
var _saves: Array = []


func _init(
	readers: Array[ReusableSaveSystem.Reader],
	migrators: Array[ReusableSaveSystem.Migrator],
	writer: ReusableSaveSystem.Writer,
) -> void:
	_writer = writer
	_create_and_wire_load_pipeline(readers, migrators)
	selection = ReusableSaveSystem.SaveSelection.new(_saves)


func _create_and_wire_load_pipeline(readers: Array[ReusableSaveSystem.Reader], migrators: Array[ReusableSaveSystem.Migrator]) -> void:
	var migration_pipeline := ReusableSaveSystem.MigrationPipeline.new(migrators)
	_load_pipeline = ReusableSaveSystem.LoadPipeline.new(readers, migration_pipeline)
	_load_pipeline.data_loaded_value.connect(_on_data_loaded)
	_load_pipeline.all_readers_responded.connect(all_readers_responded.emit)


## Fresh load. Will clear repository and selection.
func load() -> void:
	_saves.clear()
	selection.clear()
	_load_pipeline.load()


func _on_data_loaded(save_data: Variant) -> void:
	_saves.append(save_data)


func add_and_select(save_data: Variant) -> void:
	_saves.append(save_data)
	selection.selected_save_index = _saves.size() - 1


func save() -> void:
	if selection.is_selection_valid():
		_save(selection.selected_save)


func _save(save_data: Variant) -> void:
	_writer.write(save_data)
