extends PopupDialog


func _on_ContinueButton_pressed():
	get_tree().paused = false
	hide()
