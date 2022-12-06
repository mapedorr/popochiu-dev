extends EditorExportPlugin

func _export_begin(features: PackedStringArray, is_debug: bool, path: String, flags: int) -> void:
	var file = FileAccess.new()
	
	if file.open(PopochiuResources.DATA, FileAccess.READ):
		add_file(PopochiuResources.DATA, file.get_buffer(file.get_length()), false)
	
	file.close()
