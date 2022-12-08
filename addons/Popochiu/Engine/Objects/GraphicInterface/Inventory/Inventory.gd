extends Control
# warning-ignore-all:return_value_discarded

var is_disabled := false

var _can_hide_inventory := true

@onready var _hide_y := position.y - (size.y - 4)
@onready var _box: BoxContainer = find_child('Box')


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ GODOT ░░░░
func _ready():
	if not E.settings.inventory_always_visible:
		position.y = _hide_y
		
		# Connect to self signals
		connect('mouse_entered',Callable(self,'_open'))
		connect('mouse_exited',Callable(self,'_close'))
	
	# Check if there are already items in the inventory (set manually in the scene)
	for ii in _box.get_children():
		if ii is PopochiuInventoryItem:
			ii.in_inventory = true
			ii.connect('description_toggled',Callable(self,'_show_item_info'))
			ii.connect('selected',Callable(self,'_change_cursor'))
	
	# Conectarse a las señales del papá de los inventarios
	I.connect('item_added',Callable(self,'_add_item'))
	I.connect('item_removed',Callable(self,'_remove_item'))
	I.connect('inventory_show_requested',Callable(self,'_show_and_hide'))
	I.connect('inventory_hide_requested',Callable(self,'disable'))


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PUBLIC ░░░░
func disable(use_tween := true) -> void:
	is_disabled = true
	
	if E.settings.inventory_always_visible:
		hide()
		return
	
	if use_tween:
		$Tween.interpolate_property(
			self, 'position:y',
			_hide_y, _hide_y - 4.5,
			0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT
		)
		$Tween.start()
	else:
		$Tween.remove_all()
		position.y = _hide_y - 4.5


func enable() -> void:
	is_disabled = false
	
	if E.settings.inventory_always_visible:
		show()
		return
	
	$Tween.interpolate_property(
		self, 'position:y',
		_hide_y - 3.5, _hide_y,
		0.3, Tween.TRANS_SINE, Tween.EASE_OUT
	)
	$Tween.start()


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ PRIVATE ░░░░
func _open() -> void:
	if E.settings.inventory_always_visible: return
	if not is_disabled and position.y != _hide_y: return
	
	$Tween.interpolate_property(
		self, 'position:y',
		_hide_y if not is_disabled else position.y, 0.0,
		0.5, Tween.TRANS_EXPO, Tween.EASE_OUT
	)
	$Tween.start()


func _close() -> void:
	if E.settings.inventory_always_visible: return
	
	await get_tree().idle_frame
	
	if not _can_hide_inventory: return
	
	$Tween.interpolate_property(
		self, 'position:y',
		0.0, _hide_y if not is_disabled else _hide_y - 3.5,
		0.2, Tween.TRANS_SINE, Tween.EASE_IN
	)
	$Tween.start()


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
		await get_tree().idle_frame

	I.emit_signal('item_add_done', item)


func _remove_item(item: PopochiuInventoryItem, animate := true) -> void:
	item.disconnect('description_toggled',Callable(self,'_show_item_info'))
	item.disconnect('selected',Callable(self,'_change_cursor'))
	
	_box.remove_child(item)
	
	if not E.settings.inventory_always_visible:
		_can_hide_inventory = true
		
		Cursor.set_cursor()
		G.show_info()
		
		if animate:
			_close()
			await get_tree().create_timer(1.0).timeout
	
	await get_tree().idle_frame
	
	I.emit_signal('item_remove_done', item)


func _show_and_hide(time := 1.0) -> void:
	_open()
	
	await $Tween.tween_all_completed
	await E.wait(time, false)
	
	_close()
	
	await $Tween.tween_all_completed
	
	I.emit_signal('inventory_shown')
