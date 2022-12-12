extends Control
# warning-ignore-all:return_value_discarded

var is_disabled := false

var _can_hide_inventory := true

@onready var _tween := create_tween()
@onready var _hide_y := position.y - (size.y - 4)
@onready var _box: BoxContainer = find_child('Box')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	if not E.settings.inventory_always_visible:
		position.y = _hide_y
		
		# Connect to self signals
		mouse_entered.connect(_open)
		mouse_exited.connect(_close)
	
	# Check if there are already items in the inventory (set manually in the scene)
	for ii in _box.get_children():
		if ii is PopochiuInventoryItem:
			ii.in_inventory = true
			ii.description_toggled.connect(_show_item_info)
			ii.selected.connect(_change_cursor)
	
	# Conectarse a las señales del papá de los inventarios
	I.item_added.connect(_add_item)
	I.item_removed.connect(_remove_item)
	I.inventory_show_requested.connect(_show_and_hide)
	I.inventory_hide_requested.connect(disable)


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func disable(use_tween := true) -> void:
	is_disabled = true
	
	if E.settings.inventory_always_visible:
		hide()
		return
	
	if use_tween:
		_tween.stop()
		_tween.tween_property(self, 'position:y', _hide_y - 4.5, 0.3)\
		.from_current().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
		_tween.play()
	else:
		_tween.kill()
		position.y = _hide_y - 4.5


func enable() -> void:
	is_disabled = false
	
	if E.settings.inventory_always_visible:
		show()
		return
	
	_tween.stop()
	_tween.tween_property(self, 'position:y', _hide_y, 0.3)\
	.from(_hide_y - 3.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	_tween.play()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _open() -> void:
	if E.settings.inventory_always_visible: return
	if not is_disabled and position.y != _hide_y: return
	
	_tween.stop()
	_tween.tween_property(self, 'position:y', 0.0, 0.5)\
	.from(_hide_y if not is_disabled else position.y)\
	.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	_tween.play()


func _close() -> void:
	if E.settings.inventory_always_visible: return
	
	await get_tree().process_frame
	
	if not _can_hide_inventory: return
	
	_tween.stop()
	_tween.tween_property(
		self, 'position:y',
		_hide_y if not is_disabled else _hide_y - 3.5,
		0.2
	).from(0.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	_tween.play()


func _show_item_info(description := '') -> void:
	_can_hide_inventory = false if description else true


func _change_cursor(item: PopochiuInventoryItem) -> void:
	I.set_active_item(item)


func _add_item(item: PopochiuInventoryItem, animate := true) -> void:
	_box.add_child(item)
	
	item.connect('description_toggled',Callable(self,'_show_item_info'))
	item.connect('selected',Callable(self,'_change_cursor'))
	
	if not E.settings.inventory_always_visible and animate:
		_open()
		await get_tree().create_timer(2.0).timeout
		_close()
		await get_tree().create_timer(0.5).timeout
	else:
		await get_tree().process_frame
	
	I.item_add_done.emit(item)


func _remove_item(item: PopochiuInventoryItem, animate := true) -> void:
	item.description_toggled.disconnect(_show_item_info)
	item.selected.disconnect(_change_cursor)
	
	_box.remove_child(item)
	
	if not E.settings.inventory_always_visible:
		_can_hide_inventory = true
		
		Cursor.set_cursor()
		G.show_info()
		
		if animate:
			_close()
			await get_tree().create_timer(1.0).timeout
	
	await get_tree().process_frame
	
	I.item_remove_done.emit(item)


func _show_and_hide(time := 1.0) -> void:
	_open()
	
	await _tween.tween_all_completed
	await E.wait(time, false)
	
	_close()
	
	await _tween.tween_all_completed
	
	I.inventory_shown.emit()
