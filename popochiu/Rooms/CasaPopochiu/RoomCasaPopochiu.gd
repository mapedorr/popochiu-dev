tool
extends PopochiuRoom

var state: PopochiuRoomData = preload('RoomCasaPopochiu.tres')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	if Engine.editor_hint: return


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# What happens when Popochiu loads the room. At this point the room is in the
# tree but it is not visible
func on_room_entered() -> void:
#	yield(E.run([A.play_music('mx_classic')]), 'completed')
	pass


# What happens when the room changing transition finishes. At this point the room
# is visible.
func on_room_transition_finished() -> void:
#	if state.visited_first_time:
#		E.run([
#			'Player: Hi Popsy!',
#			'Popsy: Hi Goddiu',
#			'Player: How are ya?',
#			'Popsy[]: Fine, and',
#			'Player: That is great! And what are you doing?',
#			'Popsy[]: Well, I was',
#			'Player: Interesting!'
#		])
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
# You could put public functions here


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
# You could put private functions here
