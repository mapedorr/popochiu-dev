@tool
class_name PopochiuProp
extends PopochiuClickable
@icon('res://addons/Popochiu/icons/prop.png')
# Visual elements in the Room. Can have interaction.
# E.g. Background, foreground, a table, a cup, etc.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

signal linked_item_removed(node)
signal linked_item_discarded(node)

@export var texture: Texture2D : set = set_texture
@export var frames := 1:
	set = set_frames # (int, 1, 100)
@export var current_frame := 0:
	set = set_current_frame # (int, 0, 99)
@export var link_to_item := ''

@onready var _sprite: Sprite2D = $Sprite2D


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	add_to_group('props')
	
	if not clickable:
		if get_node_or_null('InteractionPolygon'):
			$InteractionPolygon.hide()
		elif get_node_or_null('CollisionPolygon2D'):
			$CollisionPolygon2D.hide()
	
	if Engine.is_editor_hint(): return
	
	for c in get_children():
		if c.get('position') is Vector2:
			c.position.y -= baseline * c.scale.y
		elif c.get('position') is Vector2:
			c.position.y -= baseline * c.scale.y
	
	walk_to_point.y -= baseline * scale.y
	position.y += baseline * scale.y
	
	if always_on_top:
		z_index += 1
	
	if link_to_item:
		I.connect('item_added',Callable(self,'_on_item_added'))
		I.connect('item_removed',Callable(self,'_on_item_removed'))
		I.connect('item_discarded',Callable(self,'_on_item_discarded'))
		
		if I.is_item_in_inventory(link_to_item):
			disable(false)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func on_linked_item_removed() -> void:
	pass


func on_linked_item_discarded() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func change_frame(new_frame: int) -> void:
#	yield()
	
	self.current_frame = new_frame
	await get_tree().process_frame


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ SET & GET ░░░░
func set_texture(value: Texture2D) -> void:
	texture = value
	$Sprite2D.texture = value


func set_frames(value: int) -> void:
	frames = value
	$Sprite2D.hframes = value


func set_current_frame(value: int) -> void:
	current_frame = value
	
	if current_frame >= $Sprite2D.hframes:
		current_frame = $Sprite2D.hframes - 1
	
	$Sprite2D.frame = current_frame


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _on_item_added(item: PopochiuInventoryItem, _animate: bool) -> void:
	if item.script_name == link_to_item:
		disable(false)


func _on_item_removed(item: PopochiuInventoryItem, _animate: bool) -> void:
	if item.script_name == link_to_item:
		on_linked_item_removed()
		emit_signal('linked_item_removed', self)


func _on_item_discarded(item: PopochiuInventoryItem) -> void:
	if item.script_name == link_to_item:
		enable(false)
		
		on_linked_item_discarded()
		emit_signal('linked_item_discarded', self)
