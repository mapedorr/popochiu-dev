tool
extends PopochiuCharacter
# You can use E.run([]) to trigger a sequence of events.
# Use yield(E.run([]), 'completed') if you want to pause the excecution of
# the function until the sequence of events finishes.

var state: PopochiuCharacterData = preload('CharacterPopsy.tres')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# When the node is clicked
func on_interact() -> void:
	C.player = self


# When the node is right clicked
func on_look() -> void:
	# Replace the call to .on_look() to implement your code. This only makes
	# the default behavior to happen.
	if state.is_hungry:
		state.is_hungry = false
		E.run([
			'Goddiu: ¡oñiiii mi pepechí!',
			'Popsy: ¡Tengo hambre!'
		])
	else:
		E.run([
			'Goddiu: ¡oñiiii mi pepechí!',
			'Popsy: oñiiiiiiiiiiiiiii',
			'Popsy: Ya me comí un ' + state.wants
		])


# When the node is clicked and there is an inventory item selected
func on_item_used(item: PopochiuInventoryItem) -> void:
	# Replace the call to .on_item_used(item) to implement your code. This only
	# makes the default behavior to happen.
	.on_item_used(item)


# Use it to play the idle animation for the character
func play_idle() -> void:
	pass


# Use it to play the walk animation for the character
# target_pos can be used to know the movement direction
func play_walk(target_pos: Vector2) -> void:
	.play_walk(target_pos)


# Use it to play the talk animation for the character
func play_talk() -> void:
	pass


# Use it to play the grab animation for the character
func play_grab() -> void:
	pass
