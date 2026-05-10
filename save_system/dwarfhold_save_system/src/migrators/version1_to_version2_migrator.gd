extends ReusableSaveSystem.Migrator

const ValidationKeyCreator := preload("../validation_key_creator.gd")


## Can migrate any save data that is dictionary and does NOT have metadata
func can_migrate(save_data: Variant) -> bool:
	if not save_data is Dictionary:
		return false
	if save_data.has("metadata"):
		return false
	return true


func migrate(raw_save_data: Variant) -> Variant:
	if not raw_save_data is Dictionary:
		return null
	return migrate_typed(raw_save_data as Dictionary)


func migrate_typed(save_data: Dictionary) -> Dictionary[String, Variant]:
	print(JSON.stringify(save_data, "\t"))

	return {
		"metadata": _create_metadata(save_data),
		"data": save_data
	} as Dictionary[String, Variant]


func _create_metadata(save_data: Dictionary) -> Dictionary[String, Variant]:
	return {
		"schema_version": 2,
		"data_validation_key": ValidationKeyCreator.create_validation_key(save_data)
	} as Dictionary[String, Variant]
