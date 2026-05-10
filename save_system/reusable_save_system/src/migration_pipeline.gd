## Handles migrating saves.
##
## How migration works
## For a given save_data object, all migrators from the newest migrator that can handle the data are invoked.
## Subsequent migrators are expected to be able to migrate. If not, an error is pushed.

var _migrators: Array[ReusableSaveSystem.Migrator]


## Migrators are to be ordered by oldest first -> final migrator puts data in current version.
func _init(migrators: Array[ReusableSaveSystem.Migrator]) -> void:
	_migrators = migrators


func migrate(save_data: Variant) -> Variant:
	var first_migrator_index := _get_newest_migrator_index_that_can_handle_data(save_data)

	# Already up to date?
	if first_migrator_index == -1:
		return save_data

	return _migrate_from_start_migrator_index(save_data, first_migrator_index)


func _get_newest_migrator_index_that_can_handle_data(save_data: Variant) -> int:
	for migrator_index in range(_migrators.size() - 1, -1, -1):
		if _migrators[migrator_index].can_migrate(save_data):
			return migrator_index
	return -1


func _migrate_from_start_migrator_index(save_data: Variant, first_migrator_index: int) -> Variant:

	for migrator_index in range(first_migrator_index, _migrators.size()):
		var migrator := _migrators[migrator_index]

		if not migrator.can_migrate(save_data):
			push_error("Migrator %s (index=%s) expected to be able to migrate data as a previous migrator could. Skipping migrator." % [migrator, migrator_index])
			continue

		save_data = migrator.migrate(save_data)

	return save_data
