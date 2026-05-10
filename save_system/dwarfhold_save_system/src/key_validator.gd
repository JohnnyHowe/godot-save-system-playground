extends ReusableSaveSystem.Validator

const ValidationKeyCreator := preload("./validation_key_creator.gd")


const VALID_KEY_TYPES: Array[Variant.Type] = [
	TYPE_STRING,
	TYPE_STRING_NAME
]


func is_valid(save_data: Variant) -> bool:
	var data_error_string := get_validation_error_string(save_data)
	if not data_error_string.is_empty():
		push_error(data_error_string)
		return false
	return true


static func get_validation_error_string(save_data: Dictionary) -> StringName:
	# Do all the required keys exist?
	if not save_data.has("data"):
		return "No data entry."
	if not save_data.has("metadata"):
		return "No metadata entry."
	if not save_data.get("metadata").has("data_validation_key"):
		return "No metadata/data_validation_key entry."
	
	# Is the validation key a string?
	var loaded_validation_key = save_data.get("metadata").get("data_validation_key")
	if not _is_valid_key_type(loaded_validation_key):
		return "Value at metadata/data_validation_key is not the correct type."

	var recreated_validation_key := ValidationKeyCreator.create_validation_key(save_data.get("data"))

	if loaded_validation_key != recreated_validation_key:
		return "Loaded key does not match key recreated from the data!"

	return ""


static func _is_valid_key_type(key: Variant) -> bool:
	return VALID_KEY_TYPES.has(typeof(key))
