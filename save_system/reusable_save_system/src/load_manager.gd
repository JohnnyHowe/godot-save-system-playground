## Orchestrates the loading side of the save system.

signal data_loaded_value
signal data_loaded

var _readers: Array[ReusableSaveSystem.Reader]
var _migration_pipeline: ReusableSaveSystem.MigrationPipeline

var _loaded_data: Array[Variant] = []


func _init(readers: Array[ReusableSaveSystem.Reader], migration_pipeline: ReusableSaveSystem.MigrationPipeline) -> void:
	_readers = readers
	_migration_pipeline = migration_pipeline

	_wire_signals()


func _wire_signals() -> void:
	data_loaded_value.connect(func(_data): data_loaded.emit())
	data_loaded.connect(print.bind("ReusableSaveSystem.LoadManager.data_loaded emitted"))

	for reader in _readers:
		reader.data_read.connect(_on_reader_data_read.bind(reader))


## Same as load but stops after the first valid save data is found.
func load_first() -> void:
	NotImplementedError.new()


## Load all saves from readers and migrate all.
func load_all() -> void:
	for reader in _readers:
		reader.read()


func _on_reader_data_read(data: Variant, reader: ReusableSaveSystem.Reader) -> void:
	print("ReusableSaveSystem.LoadManager recieved data from %s" % reader)

	var migrated_data = _migration_pipeline.migrate(data)

	if migrated_data != null:
		_loaded_data.append(migrated_data)
		data_loaded_value.emit(migrated_data)
