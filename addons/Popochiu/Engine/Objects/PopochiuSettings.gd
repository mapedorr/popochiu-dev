extends Resource

export var skip_cutscene_time := 0.2
export var text_speeds := [0.1, 0.01, 0.0]
export var text_speed_idx := 0 setget _set_text_speed_idx
export var text_continue_auto := false
export var languages := ['es_CO', 'es', 'en']
export(int, 'co', 'es', 'en') var language_idx := 0 setget _set_language_idx
export var use_translations := false
export var items_on_start := []
export var inventory_limit := 0
export var inventory_always_visible := false
export var toolbar_always_visible := false


func _set_text_speed_idx(value: int) -> void:
	text_speed_idx = value
	
	E.emit_signal('text_speed_changed', text_speed_idx)


func _set_language_idx(value: int) -> void:
	language_idx = value
	
	TranslationServer.set_locale(languages[value])
	E.emit_signal('language_changed')
