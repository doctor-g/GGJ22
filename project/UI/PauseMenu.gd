extends PopupDialog

onready var _continue_button := $CenterContainer/VBoxContainer/ContinueButton
onready var _game_options := $CenterContainer/VBoxContainer/GameOptionsControl
onready var _exit_button := $CenterContainer/VBoxContainer/ExitButton

func _ready():
	# Hide exit button on web build
	if OS.get_name() == "HTML5":
		_exit_button.visible = false


func _input(event):
	if visible and event.is_action_pressed("pause"):
		accept_event()
		_dismiss()


func show():
	.show()
	_game_options.update_toggle_state()
	_continue_button.grab_focus()


func _dismiss():
	get_tree().paused = false
	hide()


func _on_ContinueButton_pressed():
	_dismiss()


func _on_MainMenuButton_pressed():
	get_tree().paused = false
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://UI/StartMenu.tscn")


func _on_ExitButton_pressed():
	get_tree().quit(0)
