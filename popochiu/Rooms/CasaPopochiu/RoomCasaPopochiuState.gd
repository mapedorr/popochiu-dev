extends PopochiuRoomData

export var pera := ''

var banano := ''


func on_save() -> Dictionary:
	return {
		drink = 'café',
	}


func on_load(data: Dictionary) -> void:
	prints('La bebida que quiero es', data.drink)
