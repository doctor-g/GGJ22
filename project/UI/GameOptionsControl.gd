extends VBoxContainer

onready var _fullscreen_toggle := $FullscreenToggle


func update_toggle_state()->void:
	_fullscreen_toggle.pressed = OS.window_fullscreen


func _on_FullscreenToggle_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
