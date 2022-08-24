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
		rooms = {}, # Stores the state of each PopochiuRoomData
		characters = {}, # Stores the state of each PopochiuCharacterData
		inventory_items = {}, # Stores the state of each PopochiuInventoryItemData
		dialogs = {}, # Stores the state of each PopochiuDialog
	}
	
	# Go over each Popochiu type to save its current state ---------------------
	for type in ['rooms', 'characters', 'inventory_items', 'dialogs']:
		_store_data(type, data)
	
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

# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _store_data(type: String, save: Dictionary) -> void:
	for path in PopochiuResources.get_section(type):
		var data := load(path)
		
		save[type][data.script_name] = {}
		
		for prop in data.get_script().get_script_property_list():
			# prop = {class_name, hint, hint_string, name, type, usage}
			if prop.name == 'script_name' or prop.name == 'scene'\
			or not prop.type in VALID_TYPES:
				continue
			
			# Check if the property is a script variable (8192)
			# or a export variable (8199)
			if prop.usage == PROPERTY_USAGE_SCRIPT_VARIABLE or prop.usage == (
				PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
			):
				save[type][data.script_name][prop.name] = data[prop.name]
