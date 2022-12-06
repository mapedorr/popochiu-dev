class_name PopochiuRoomData
extends Resource
@icon('res://addons/Popochiu/icons/room.png')

@export var script_name := ''
@export_file("*.tscn") var scene := ''

@export var visited := false
@export var visited_first_time := false
@export var visited_times := 0
