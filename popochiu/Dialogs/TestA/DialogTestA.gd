tool
extends PopochiuDialog


# ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ VIRTUAL ░░░░
func on_start() -> void:
	yield(E.run([]), 'completed')


func option_selected(opt: PopochiuDialogOption) -> void:
	# Use match to check which option was selected and excecute something for
	# each one
	yield(E.run([
		'Player:' + opt.text
	]), 'completed')
	
	match opt.id:
		'Opt1':
			opt.turn_off_forever()
			turn_on_options(['Opt2'])
		'Opt2':
			turn_on_options(['Opt1'])
		_:
			# By default close the dialog
			stop()
	
	_show_options()
