tool
extends PopochiuHotspot
# You can use E.run([]) to trigger a sequence of events.
# Use yield(E.run([]), 'completed') if you want to pause the excecution of
# the function until the sequence of events finishes.


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
# When the node is clicked
func on_interact() -> void:
	yield(E.run([
		G.display('Holaaaaaa'),
		G.display(\
		'cacaskcj alskcj [shake]alsckj[/shake] alskcjas lckja [wave]lcascasdadsa[/wave] askdjf aslkdjf laskdjf alsdkfj yyyyyyy alskdjf xxxxxx '),
		G.display('Ouch'),
	]), 'completed')


# When the node is right clicked
func on_look() -> void:
	E.run([
		'Player: Esta foto de los popochius es muuuuuuy bonia',
		'Player: iiiiiiiiii',
		'Player: [wave]Qué chistosiu[/wave]'
	])


# When the node is clicked and there is an inventory item selected
func on_item_used(item: PopochiuInventoryItem) -> void:
	# Replace the call to .on_item_used(item) to implement your code. This only
	# makes the default behavior to happen.
	.on_item_used(item)
