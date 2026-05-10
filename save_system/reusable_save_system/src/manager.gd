## Facade to the whole save system.
## Allows saving and loading with backwards compatability.
## Delegates everything.

var _load_pipeline: ReusableSaveSystem.LoadPipeline
var _writer: ReusableSaveSystem.Writer
var _validators: Array[ReusableSaveSystem.Validator]

var _repository: ReusableSaveSystem.LoadedSaveRepository


func _init(
	readers: Array[ReusableSaveSystem.Reader],
	migrators: Array[ReusableSaveSystem.Migrator],
	writer: ReusableSaveSystem.Writer,
	validators: Array[ReusableSaveSystem.Validator] = []
) -> void:
	_writer = writer
	_validators = validators
	_create_and_wire_load_pipeline(readers, migrators)


func _create_and_wire_load_pipeline(readers: Array[ReusableSaveSystem.Reader], migrators: Array[ReusableSaveSystem.Migrator]) -> void:
	var migration_pipeline := ReusableSaveSystem.MigrationPipeline.new(migrators)
	_load_pipeline = ReusableSaveSystem.LoadPipeline.new(readers, migration_pipeline)
	_load_pipeline.data_loaded_value.connect(_on_data_loaded)


## Fresh load. Will clear repository and selection.
func load() -> void:
	_repository = ReusableSaveSystem.LoadedSaveRepository.new()
	_load_pipeline.load_all()


func _on_data_loaded(save_data: Variant) -> void:
	if _is_data_valid(save_data):
		_repository.add_save(save_data)


func _is_data_valid(save_data: Variant) -> bool:
	for validator in _validators:
		if not validator.is_valid(save_data):
			return false
	return true


func save() -> void:
	if _repository.selected_save:
		_save(_repository.selected_save)


func _save(save_data: Variant) -> void:
	_writer.write(save_data)
