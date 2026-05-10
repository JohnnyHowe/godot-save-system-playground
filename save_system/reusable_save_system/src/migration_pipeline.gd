## Handles migrating saves.

var _migrators: Array[ReusableSaveSystem.Migrator]


func _init(migrators: Array[ReusableSaveSystem.Migrator]) -> void:
	_migrators = migrators


func migrate(save_data: RefCounted) -> RefCounted:
	NotImplementedError.new()
	return null
