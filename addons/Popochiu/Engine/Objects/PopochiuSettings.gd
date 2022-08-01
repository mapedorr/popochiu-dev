tool
extends Resource
class_name PopochiuSettings

export var game_width: int = 0 setget set_game_width
export var game_height: int = 0 setget set_game_height
export(PackedScene) var graphic_interface = null
export(PackedScene) var transition_layer = null
export var skip_cutscene_time := 0.2
export var text_speeds := [0.1, 0.01, 0.0]
export var text_speed_idx := 0
export var text_continue_auto := false
export var languages := ['en', 'es', 'es_CO']
export(int, 'en', 'es', 'co') var language_idx := 0
export var use_translations := false
export var items_on_start := []
export var inventory_limit := 0
export var inventory_always_visible := false
export var toolbar_always_visible := false
export var fade_color: Color = Color.black


func _init() -> void:
	game_width = ProjectSettings.get_setting('display/window/size/width')
	game_height = ProjectSettings.get_setting('display/window/size/height')


func set_game_width(value: int) -> void:
	game_width = value
	
	if Engine.editor_hint:
		ProjectSettings.set_setting('display/window/size/width', value)
		
		var result = ProjectSettings.save()
		assert(result == OK, '[Popochiu] Failed to save project settings.')


func set_game_height(value: int) -> void:
	game_height = value
	
	if Engine.editor_hint:
		ProjectSettings.set_setting('display/window/size/height', value)
		
		var result = ProjectSettings.save()
		assert(result == OK, '[Popochiu] Failed to save project settings.')
