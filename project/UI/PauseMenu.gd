extends PopupDialog

onready var _continue_button := $CenterContainer/VBoxContainer/ContinueButton

func show():
	.show()
	_continue_button.grab_focus()


func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/StartMenu.tscn")
