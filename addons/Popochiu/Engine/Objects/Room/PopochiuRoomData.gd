class_name PopochiuRoomData, 'res://addons/Popochiu/icons/room.png'
extends Resource

export var script_name := ''
export(String, FILE, "*.tscn") var scene = ''

export var visited := false
export var visited_first_time := false
export var visited_times := 0

var props := {}
var hotspots := {}
var walkable_areas := {}
var regions := {}


func save_props_states() -> void:
	if E.current_room and E.current_room.state == self:
		for prop in E.current_room.get_props():
			if not (prop as PopochiuProp).clickable: continue
			
			_save_prop_state(prop)
	elif not props:
		var props_path := resource_path.get_base_dir() + '/Props'
		var dir := Directory.new()
		
		if dir.open(props_path) == OK:
			dir.list_dir_begin(true)
			
			var folder_name := dir.get_next()
			
			while folder_name != '':
				if dir.current_is_dir() and folder_name != '_NoInteraction':
					var prop_script_path := '%s/%s/Prop%s.gd' % [
						props_path,
						folder_name,
						folder_name
					]
					
					var prop: PopochiuProp = load(prop_script_path).new()
					prop.script_name = folder_name
					
					_save_prop_state(prop)
					
					prop.free()
				
				folder_name = dir.get_next()
		else:
			print("An error occurred when trying to access the path.")


func _save_prop_state(prop: PopochiuProp) -> void:
	var prop_state := {}
	
	PopochiuResources.store_properties(
		prop_state,
		prop,
		[
			'description',
			'baseline',
			'clickable',
			'cursor',
			'always_on_top',
			'frames',
			'link_to_item',
			'_description_code',
		]
	)
	
	# Add the PopochiuProp state to the room's props
	props[prop.script_name] = prop_state
