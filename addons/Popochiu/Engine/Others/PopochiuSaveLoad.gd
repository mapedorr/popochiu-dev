extends Node
# Class for saving and loading game data.
# Thanks GDQuest for this! (https://github.com/GDQuest/godot-demos-2022/tree/main/save-game)
# ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

# TODO: This could be in PopochiuSettings for devs to change the path
const SAVE_GAME_PATH := 'user://save.json'
const VALID_TYPES := [
	TYPE_BOOL, TYPE_INT, TYPE_REAL, TYPE_STRING, TYPE_ARRAY, TYPE_DICTIONARY
]

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
	
	# Go over each Room to save its current state ------------------------------
	for rp in PopochiuResources.get_section('rooms'):
		var prd: PopochiuRoomData = load(rp)
	
		data.rooms[prd.script_name] = {}
		
		for p in prd.get_script().get_script_property_list():
			# p = {class_name, hint, hint_string, name, type, usage}
			if p.name == 'script_name' or p.name == 'scene'\
			or not p.type in VALID_TYPES:
				continue
			
			# Check if the property is a script variable (8192)
			# or a export variable (8199)
			if p.usage == PROPERTY_USAGE_SCRIPT_VARIABLE or p.usage == (
				PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
			):
				data.rooms[prd.script_name][p.name] = prd[p.name]
	
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
