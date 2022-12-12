extends ConfirmationDialog

var _name := ''
var _main_dock: Panel : set = set_main_dock

@onready var _input: LineEdit = find_child('Input')
@onready var _error_feedback: Label = find_child('ErrorFeedback')
@onready var _info: RichTextLabel = find_child('Info')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready() -> void:
	register_text_enter(_input)
	
	connect('confirmed',Callable(self,'create'))
	connect('popup_hide',Callable(self,'_clear_fields'))
	_input.connect('text_changed',Callable(self,'_update_name'))


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func set_main_dock(node: Panel) -> void:
	_main_dock = node


func create() -> void:
	pass


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _update_name(new_text: String) -> void:
	if _error_feedback.visible:
		_error_feedback.hide()
	
	var casted_name := PackedStringArray()
	for idx in new_text.length():
		if idx == 0:
			casted_name.append(new_text[idx].to_upper())
		else:
			casted_name.append(new_text[idx])

	_name = ''.join(casted_name).strip_edges()


func _clear_fields() -> void:
	_input.clear()
	_error_feedback.hide()

	_info.clear()
