class_name PathUtility

const PATH_SEPARATOR := "/"


static func join(parts: Array) -> String:
	var trimmed_parts := parts.map(func(part: String): return part.trim_prefix("/").trim_suffix("/"))
	return PATH_SEPARATOR.join(trimmed_parts)


static func get_path_parts(path: String) -> PackedStringArray:
	path = normalize_separators(path)
	return path.split(PATH_SEPARATOR)


static func normalize_separators(path: String) -> String:
	for separator in ["//", "\\", "\\\\"]:
		path = path.replace(separator, PATH_SEPARATOR)
	return path


static func get_stem(path: String) -> String:
	return path.get_basename().get_file()


static func get_full_system_path(path: String) -> String:
	# See https://docs.godotengine.org/en/latest/classes/class_projectsettings.html#class-projectsettings-method-globalize-path
	if OS.has_feature("editor"):
		# Running from an editor binary.
		# `path` will contain the absolute path to `hello.txt` located in the project root.
		return ProjectSettings.globalize_path(path)
	else:
		# Running from an exported project.
		# `path` will contain the absolute path to `hello.txt` next to the executable.
		# This is *not* identical to using `ProjectSettings.globalize_path()` with a `res://` path,
		# but is close enough in spirit.
		return OS.get_executable_path().get_base_dir().path_join(path.trim_prefix("res://"))
