extends Node
# Class for saving and loading game data.
# Thanks GDQuest for this! (https://github.com/GDQuest/godot-demos-2022/tree/main/save-game)
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

# TODO: This could be in PopochiuSettings for devs to change the path
const SAVE_GAME_PATH := 'user://save.json'

var _file := File.new()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)


# TODO: receive a parameter that indicates the slot to use for saving the game
func save_game() -> bool:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr(\
		'[Popochiu] Could not open the file %s. Error code: %s'\
		% [SAVE_GAME_PATH, error])
		return false
	
	var data := {
		player = {
			id = C.player.script_name,
			room = E.current_room.script_name,
			position = {
				x = C.player.global_position.x,
				y = C.player.global_position.y
			},
			inventory = I.items,
		},
		rooms = {}, # Stores the state of each room
		items = {}, # Stores the state of each inventory item
	}
	
	# Go over each Room to save its current state
	for room_id in E.rooms_states:
		data.rooms[room_id] = E.rooms_states[room_id]
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()
	
	return true


# TODO: receive a parameter that indicates the slot to use for loading the game
func load_game() -> Dictionary:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr(\
		'[Popochiu] Could not open the file %s. Error code: %s'\
		% [SAVE_GAME_PATH, error])
		return {}

	var content := _file.get_as_text()
	_file.close()

	return JSON.parse(content).result
