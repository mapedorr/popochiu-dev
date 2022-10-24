tool
class_name PopochiuProp, 'res://addons/Popochiu/icons/prop.png'
extends 'res://addons/Popochiu/Engine/Objects/Clickable/PopochiuClickable.gd'
# Visual elements in the Room. Can have interaction.
# E.g. Background, foreground, a table, a cup, etc.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

signal linked_item_removed(node)
signal linked_item_discarded(node)

export var texture: Texture setget _set_texture
export var link_to_item := ''
#export var parallax_depth := 1.0 setget _set_parallax_depth
#export var parallax_alignment := Vector2.ZERO

onready var _sprite: Sprite = $Sprite


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	add_to_group('props')
	
	if not clickable and get_node_or_null('CollisionPolygon2D'):
		$CollisionPolygon2D.hide()
	
	if Engine.editor_hint: return
	
	for c in get_children():
		if c.get('position') is Vector2:
			c.position.y -= baseline * c.scale.y
		elif c.get('rect_position') is Vector2:
			c.rect_position.y -= baseline * c.rect_scale.y
	
	walk_to_point.y -= baseline * scale.y
	position.y += baseline * scale.y
	
	if always_on_top:
		z_index += 1
	
	if link_to_item:
		I.connect('item_added', self, '_on_item_added')
		I.connect('item_removed', self, '_on_item_removed')
		I.connect('item_discarded', self, '_on_item_discarded')
		
		if I.is_item_in_inventory(link_to_item):
			disable(false)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func on_linked_item_removed() -> void:
	pass


func on_linked_item_discarded() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _set_texture(value: Texture) -> void:
	texture = value
	$Sprite.texture = value


#func _set_parallax_depth(value: float) -> void:
#	parallax_depth = value
##	$ParallaxLayer.motion_scale = Vector2.ONE * value
#	property_list_changed_notify()


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
