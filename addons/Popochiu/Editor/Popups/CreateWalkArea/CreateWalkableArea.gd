tool
extends 'res://addons/Popochiu/Editor/Popups/CreationPopup.gd'
# Creates a new walkable area in a room

#const SCRIPT_TEMPLATE := 'res://addons/Popochiu/Engine/Templates/WalkableAreaTemplate.gd'
const WALKABLE_AREA_SCENE := 'res://addons/Popochiu/Engine/Objects/WalkableArea/PopochiuWalkableArea.tscn'
const Constants := preload('res://addons/Popochiu/PopochiuResources.gd')

var room_tab: VBoxContainer = null

var _room: Node2D = null
var _new_walkable_area_name := ''
var _room_path: String
var _room_dir: String


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	_clear_fields()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func set_main_dock(node: PopochiuDock) -> void:
	.set_main_dock(node)


func room_opened(r: Node2D) -> void:
	_room = r
	_room_path = _room.filename
	_room_dir = _room_path.get_base_dir()


func create() -> void:
	if not _new_walkable_area_name:
		_error_feedback.show()
		return
	
	# TODO: Stop if another WalkableArea with the same name exists.
	
	# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

	# Create the new WalkableArea and add it to the room
	var walkable_area: PopochiuWalkableArea = ResourceLoader.load(WALKABLE_AREA_SCENE).instance()
	walkable_area.name = _new_walkable_area_name
	walkable_area.script_name = _new_walkable_area_name
	walkable_area.description = _new_walkable_area_name
	
	# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	# Attach the walkable area to the room
	_room.get_node('WalkableAreas').add_child(walkable_area)
	walkable_area.owner = _room
	walkable_area.position = Vector2(
		ProjectSettings.get_setting(PopochiuResources.DISPLAY_WIDTH),
		ProjectSettings.get_setting(PopochiuResources.DISPLAY_HEIGHT)
	) / 2.0
	
	var polygon := NavigationPolygonInstance.new()
	walkable_area.add_child(polygon)
	polygon.owner = _room
	
	_main_dock.ei.save_scene()
	
	# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	# Update the list of WalkableAreas in the Room tab
	room_tab.add_to_list(
		Constants.Types.WALKABLE_AREA,
		_new_walkable_area_name,
		script_path
	)
	
	# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	# Abrir las propiedades de la walkable area creada en el Inspector
	yield(get_tree().create_timer(0.1), 'timeout')
	_main_dock.ei.edit_node(walkable_area)
	
	# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
	# Fin
	hide()

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _clear_fields() -> void:
	._clear_fields()
	
	_new_walkable_area_name = ''
	_new_walkable_area_path = ''
