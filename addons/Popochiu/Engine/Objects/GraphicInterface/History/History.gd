extends Control
# warning-ignore-all:return_value_discarded

@onready var _lines_list: VBoxContainer = find_child('LinesList')
@onready var _dialog_line_path := filename.get_base_dir() + '/DialogLine.tscn'
@onready var _interaction_line_path := filename.get_base_dir() + '/InteractionLine.tscn'


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	# Conectarse a eventos de los hijos
	$Window.connect('popup_hide',Callable(self,'_destroy_history'))
	# Conectarse a eventos de singletons
	G.connect('history_opened',Callable(self,'_show_history'))
	
	hide()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _show_history() -> void:
	for data in E.history:
		var lbl: Label
		
		if data.has('character'):
			lbl = load(_dialog_line_path).instantiate()
			lbl.text = '%s: %s' % [data.character, data.text]
		else:
			lbl = load(_interaction_line_path).instantiate()
			lbl.text = '(%s)' % data.action
	
		_lines_list.add_child(lbl)
	
	if E.settings.scale_gui:
		scale = Vector2.ONE * E.scale
		$Window.scale = Vector2.ONE * E.scale
	
#	popup(Rect2(8, 16, 304, 160))
	$Window.popup_centered(Vector2(240.0, 120.0))
	
	G.emit_signal('blocked', { blocking = false })
	Cursor.set_cursor(Cursor.Type.USE)
	Cursor.block()
	
	show()


func _destroy_history() -> void:
	for c in _lines_list.get_children():
		(c as Label).queue_free()
	
	G.done()
	false # Cursor.unlock() # TODOConverter40, Image no longer requires locking, `false` helps to not break one line if/else, so it can freely be removed
	
	hide()
