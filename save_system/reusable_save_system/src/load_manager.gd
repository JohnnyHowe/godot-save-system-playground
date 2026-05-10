## Orchestrates the loading side of the save system.

var _readers: Array[ReusableSaveSystem.Reader]
var _migration_pipeline: ReusableSaveSystem.MigrationPipeline


func _init(readers: Array[ReusableSaveSystem.Reader], migrators: Array[ReusableSaveSystem.Migrator]) -> void:
	_readers = readers
	_migration_pipeline = ReusableSaveSystem.MigrationPipeline.new(migrators)
	_wire_reader_loaded_signals()


func _wire_reader_loaded_signals() -> void:
	for reader in _readers:
		reader.data_read.connect(_on_reader_data_read.bind(reader))


## Same as load but stops after the first valid save data is found.
func load_first() -> void:
	pass


## Load all saves from readers and migrate all.
func load_all() -> void:
	# for reader in _readers:
	# 	reader.load()
	pass


func _on_reader_data_read(data: RefCounted, reader: ReusableSaveSystem.Reader) -> void:
	print("data loaded from %s!" % reader)
	NotImplementedError.new()
