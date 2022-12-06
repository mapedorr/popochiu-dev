@tool
class_name PopochiuWalkableArea
extends Node2D
@icon('res://addons/Popochiu/icons/walkable_area.png')
# Areas players can walk upon.
# No specific behavior at the moment, the area is defined by a polygon.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

@export var script_name := ''
@export var description := ''
@export var enabled := true : set = _set_enabled
# TODO: If walkable is false, characters should not be able to walk through this.
#export var walkable := true
@export var tint := Color.WHITE
# TODO: Make the scale of the character change depending checked where it is placed in
# this walkable area.
#export var scale_top := 1.0
#export var scale_bottom := 1.0


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	add_to_group('walkable_areas')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func _set_enabled(value: bool) -> void:
	enabled = value
	notify_property_list_changed()
