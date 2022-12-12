@tool
class_name PopochiuHotspot
extends 'res://addons/Popochiu/Engine/Objects/Clickable/PopochiuClickable.gd'
@icon('res://addons/Popochiu/icons/hotspot.png')
# Areas players can interact with.
# E.g. Something that is part of the Room's background (the sky, an entrance).
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	add_to_group('hotspots')
