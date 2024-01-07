@tool
extends EditorScript

func listFiles(path: String, extensions: Array = []) -> Array:
	var list := []
	for dir in DirAccess.get_directories_at(path):
		if not dir.begins_with("."):
			list.append_array(listFiles(path + dir + "/", extensions))
	for file in DirAccess.get_files_at(path):
		var ext := file.split(".")[-1]
		if not file.begins_with(".") and ext != "import":
			if extensions.is_empty() or ext in extensions:
				list.append(path + file)
	return list

func _run() -> void:
	for file in listFiles("res://", ["tscn", "tres"]):
		ResourceSaver.save(load(file))

