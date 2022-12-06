@tool
class_name PopochiuCharacter
extends 'res://addons/Popochiu/Engine/Objects/Clickable/PopochiuClickable.gd'
@icon('res://addons/Popochiu/icons/character.png')
# Any Object that can move, walk, navigate rooms, have an inventory, etc.
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
# TODO: Use a state machine

enum FlipsWhen { NONE, MOVING_RIGHT, MOVING_LEFT }
enum Looking {UP, UP_RIGHT, RIGHT, RIGHT_DOWN, DOWN, DOWN_LEFT, LEFT, UP_LEFT}

signal started_walk_to(character, start, end)
signal stoped_walk

@export var text_color := Color.WHITE
@export var is_player := false
@export var flips_when: FlipsWhen = FlipsWhen.NONE
@export var voices := []:
	set = set_voices # (Array, Dictionary)
@export var follow_player := false
@export var walk_speed := 200.0
@export var can_move := true
@export var ignore_walkable_areas := false

var last_room := ''
var anim_suffix := ''
var is_moving := false
var emotion := ''

var _looking_dir: int = Looking.DOWN

@onready var dialog_pos: Marker2D = $DialogPos


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	if not Engine.is_editor_hint():
		idle(false)
		set_process(follow_player)
	else:
		hide_helpers()
		set_process(true)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func play_idle() -> void:
	pass


func play_walk(target_pos: Vector2) -> void:
	pass


func play_talk() -> void:
	pass


func play_grab() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func idle(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	if E.cutscene_skipped:
		await get_tree().idle_frame
		return
	
	play_idle()
	
	await get_tree().create_timer(0.2).timeout


func walk(target_pos: Vector2, is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	is_moving = true
	_looking_dir = Looking.LEFT if target_pos.x < position.x else Looking.RIGHT
	
	if has_node('Sprite2D'):
		match flips_when:
			FlipsWhen.MOVING_LEFT:
				$Sprite2D.flip_h = target_pos.x < position.x
			FlipsWhen.MOVING_RIGHT:
				$Sprite2D.flip_h = target_pos.x > position.x
	
	if E.cutscene_skipped:
		is_moving = false
		E.main_camera.follow_smoothing_enabled = false
		
		await get_tree().idle_frame
		
		position = target_pos
		E.main_camera.position = target_pos
		
		await get_tree().idle_frame
		
		E.main_camera.follow_smoothing_enabled = true
		
		return
	
	play_walk(target_pos)
	
	# Trigger the signal for the room  to start moving the character
	emit_signal('started_walk_to', self, position, target_pos)
	
	await C.character_move_ended
	
	is_moving = false


func stop_walking(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	is_moving = false
	
	emit_signal('stoped_walk')
	
	await get_tree().idle_frame


func face_up(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	_looking_dir = Looking.UP
	await idle(false)


func face_up_right(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	_looking_dir = Looking.UP_RIGHT
	await idle(false)


func face_down(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	_looking_dir = Looking.DOWN
	await idle(false)


func face_left(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	_looking_dir = Looking.LEFT
	
	await idle(false)


func face_right(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	_looking_dir = Looking.RIGHT
	await idle(false)


func face_clicked(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	if E.clicked.global_position < global_position:
		if has_node('Sprite2D'):
			$Sprite2D.flip_h = flips_when == FlipsWhen.MOVING_LEFT
		
		await face_left(false)
	else:
		if has_node('Sprite2D'):
			$Sprite2D.flip_h = flips_when == FlipsWhen.MOVING_RIGHT
		
		await face_right(false)


func say(dialog: String, is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	if E.cutscene_skipped:
		await get_tree().idle_frame
		return
	
	play_talk()
	
	var vo_name := _get_vo_cue(emotion)
	if vo_name:
		A.play_no_block(vo_name, false, global_position)
	
	C.emit_signal('character_spoke', self, dialog)
	
	await G.continue_clicked
	
	emotion = ''
	idle(false)


func grab(is_in_queue := true) -> void:
#	if is_in_queue: yield()
	
	if E.cutscene_skipped:
		await get_tree().idle_frame
		return
	
	play_grab()
	
	await C.character_grab_done
	
	idle(false)


func hide_helpers() -> void:
	super.hide_helpers()
	
	if is_instance_valid(dialog_pos): dialog_pos.hide()


func show_helpers() -> void:
	super.show_helpers()
	if is_instance_valid(dialog_pos): dialog_pos.show()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ SET & GET ░░░░
func get_dialog_pos() -> float:
	return $DialogPos.position.y


func set_voices(value: Array) -> void:
	voices = value
	
	for idx in value.size():
		if not value[idx]:
			voices[idx] = {
				emotion = '',
				cue = '',
				variations = 0
			}
			notify_property_list_changed()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _translate() -> void:
	if Engine.is_editor_hint() or not is_inside_tree(): return
	description = E.get_text(_description_code)


func _get_vo_cue(emotion := '') -> String:
	for v in voices:
		if v.emotion.to_lower() == emotion.to_lower():
			var cue_name: String = v.cue
			
			if v.variations:
				if not v.has('not_played') or v.not_played.is_empty():
					v['not_played'] = range(v.variations)
				
				var idx: int = (v['not_played'] as Array).pop_at(
					U.get_random_array_idx(v['not_played'])
				)
				
				cue_name += '_' + str(idx + 1).pad_zeros(2)
			
			return cue_name
	return ''
