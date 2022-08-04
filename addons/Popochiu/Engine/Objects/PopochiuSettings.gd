tool
extends Resource
class_name PopochiuSettings

const ImporterDefaults := preload('res://addons/Popochiu/Engine/Others/ImporterDefaults.gd')

export var game_width: int = 0 setget set_game_width
export var game_height: int = 0 setget set_game_height
export var test_width: int = 0 setget set_test_width
export var test_height: int = 0 setget set_test_height
export(int, 'Default', '2D', 'Pixel') var game_type := 0 setget set_game_type
export(PackedScene) var graphic_interface = null
export(PackedScene) var transition_layer = null
export var skip_cutscene_time := 0.2
export var text_speeds := [0.1, 0.01, 0.0]
export var default_text_speed := 0
export var auto_continue_text := false
export var languages := ['en', 'es', 'es_CO']
export(int, 'en', 'es', 'co') var default_language := 0
export var use_translations := false
export var items_on_start := []
export var inventory_limit := 0
export var inventory_always_visible := false
export var toolbar_always_visible := false
export var fade_color: Color = Color.black


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _init() -> void:
	game_width = ProjectSettings.get_setting('display/window/size/width')
	game_height = ProjectSettings.get_setting('display/window/size/height')
	test_width = ProjectSettings.get_setting('display/window/size/test_width')
	test_height = ProjectSettings.get_setting('display/window/size/test_height')
	
	if ProjectSettings.get_setting('display/window/stretch/mode') == '2d'\
	and ProjectSettings.get_setting('display/window/stretch/aspect') == 'keep':
		game_type = 1
		
		if ProjectSettings.get_setting('importer_defaults/texture')\
		== ImporterDefaults.PIXEL_TEXTURES:
			game_type = 2


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ SET & GET ░░░░
func set_game_width(value: int) -> void:
	game_width = value
	
	if not Engine.editor_hint: return
	
	ProjectSettings.set_setting('display/window/size/width', value)
	
	_save_settings()


func set_game_height(value: int) -> void:
	game_height = value
	
	if not Engine.editor_hint: return
	
	ProjectSettings.set_setting('display/window/size/height', value)
	
	_save_settings()


func set_test_width(value: int) -> void:
	test_width = value
	
	if not Engine.editor_hint: return
	
	ProjectSettings.set_setting('display/window/size/test_width', value)
	
	_save_settings()


func set_test_height(value: int) -> void:
	test_height = value
	
	if not Engine.editor_hint: return
	
	ProjectSettings.set_setting('display/window/size/test_height', value)
	
	_save_settings()


func set_game_type(value: int) -> void:
	game_type = value
	
	if not Engine.editor_hint: return
		
	if value != 0:
		ProjectSettings.set_setting('display/window/stretch/mode', '2d')
		ProjectSettings.set_setting('display/window/stretch/aspect', 'keep')
		
		if value == 1:
			ProjectSettings.set_setting(
				'importer_defaults/texture',
				null
			)
		else:
			ProjectSettings.set_setting(
				'importer_defaults/texture',
				ImporterDefaults.PIXEL_TEXTURES
			)
		
	else:
		ProjectSettings.set_setting('display/window/stretch/mode', 'disabled')
		ProjectSettings.set_setting('display/window/stretch/aspect', 'ignore')
	
	_save_settings()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _save_settings() -> void:
	var result = ProjectSettings.save()
	assert(result == OK, '[Popochiu] Failed to save project settings.')
