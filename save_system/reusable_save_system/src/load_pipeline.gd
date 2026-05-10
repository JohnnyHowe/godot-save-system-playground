## Orchestrates the loading side of the save system.

signal all_readers_responded
signal data_loaded_value(data: Variant)
signal data_loaded

const _N_READERS_UNFINISHED_NOT_SET = -1

var _readers: Array[ReusableSaveSystem.Reader]
var _migration_pipeline: ReusableSaveSystem.MigrationPipeline

var _loaded_data: Array[Variant] = []

var _n_readers_unfinished: int = _N_READERS_UNFINISHED_NOT_SET:
	set(value):
		_n_readers_unfinished = value
		if _n_readers_unfinished == 0:
			all_readers_responded.emit()


func _init(readers: Array[ReusableSaveSystem.Reader], migration_pipeline: ReusableSaveSystem.MigrationPipeline) -> void:
	_readers = readers
	_migration_pipeline = migration_pipeline
	_wire_signals()


func _wire_signals() -> void:
	data_loaded_value.connect(func(_data): data_loaded.emit())
	data_loaded.connect(print.bind("ReusableSaveSystem.LoadManager.data_loaded emitted"))


## Load all saves from readers and migrate all.
func load() -> void:
	_n_readers_unfinished = _readers.size()
	for reader in _readers:
		_load_reader(reader)


func _load_reader(reader: ReusableSaveSystem.Reader) -> void:
	_clear_all_connections(reader)
	reader.data_read.connect(_on_first_data_read_for_reader.bind(reader), CONNECT_ONE_SHOT)
	reader.no_data_found.connect(_on_first_no_data_found_for_reader.bind(reader), CONNECT_ONE_SHOT)
	reader.read()


func _on_first_data_read_for_reader(data: Variant, reader: ReusableSaveSystem.Reader) -> void:
	_n_readers_unfinished -= 1
	_connect_multiple_emit_error_signals(reader)

	var migrated_data = _migration_pipeline.migrate(data)

	if migrated_data != null:
		_loaded_data.append(migrated_data)
		data_loaded_value.emit(migrated_data)


func _on_first_no_data_found_for_reader(reader: ReusableSaveSystem.Reader) -> void:
	_n_readers_unfinished -= 1
	_connect_multiple_emit_error_signals(reader)


func _connect_multiple_emit_error_signals(reader: ReusableSaveSystem.Reader) -> void:
	_clear_all_connections(reader)
	reader.data_read.connect(push_error.bind("Save reader %s emitted signals multiple time, only once is allowed. Got `data_read`." % reader))
	reader.no_data_found.connect(push_error.bind("Save reader %s emitted signals multiple time, only once is allowed. Got `no_data_found`." % reader))


func _clear_all_connections(reader: ReusableSaveSystem.Reader) -> void:
	_disconnect_if_connected(reader.data_read, _on_first_data_read_for_reader)
	_disconnect_if_connected(reader.data_read, push_error)
	_disconnect_if_connected(reader.no_data_found, _on_first_no_data_found_for_reader)
	_disconnect_if_connected(reader.no_data_found, push_error)
	

static func _disconnect_if_connected(target: Signal, method: Callable) -> void:
	if target.is_connected(method):
		target.disconnect(method)
