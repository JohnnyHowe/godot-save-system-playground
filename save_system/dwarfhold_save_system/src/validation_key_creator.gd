const DEFINITELY_NOT_A_SECURITY_KEY_IN_CODE: StringName = "jonward to victory!"


static func create_validation_key(save_data: Dictionary) -> StringName:
	return _get_validation_key(save_data, DEFINITELY_NOT_A_SECURITY_KEY_IN_CODE)


static func _get_validation_key(save_data: Dictionary, key: String) -> StringName:
	return _xor_obfuscate(_get_hash(save_data), key)


static func _get_hash(data: Dictionary) -> StringName:
	var json := JSON.stringify(data, "", true, true)
	return json.sha256_text()


static func _xor_obfuscate(text: String, key: String) -> String:
	var data := text.to_utf8_buffer()
	var key_bytes := key.to_utf8_buffer()

	for i in data.size():
		data[i] = data[i] ^ key_bytes[i % key_bytes.size()]

	return Marshalls.raw_to_base64(data)
