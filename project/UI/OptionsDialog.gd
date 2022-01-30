extends PopupDialog

onready var _ok_button := $CenterContainer/VBoxContainer/OkButton

func show():
	.show()
	_ok_button.grab_focus()


func _on_OkButton_pressed():
	hide()
