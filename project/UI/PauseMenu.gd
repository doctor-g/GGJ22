extends PopupDialog

onready var _continue_button := $CenterContainer/ContinueButton

func show():
	.show()
	_continue_button.grab_focus()


func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()
