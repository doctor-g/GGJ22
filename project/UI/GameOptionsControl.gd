extends VBoxContainer

onready var _music_bus := AudioServer.get_bus_index("Music")
onready var _sfx_bus := AudioServer.get_bus_index("SFX")
onready var _fullscreen_toggle := $FullscreenToggle
onready var _music_toggle := $MuteMusicToggle
onready var _sfx_toggle := $MuteSoundToggle


func update_toggle_state()->void:
	_fullscreen_toggle.pressed = OS.window_fullscreen
	_music_toggle.pressed = AudioServer.is_bus_mute(_music_bus)
	_sfx_toggle.pressed = AudioServer.is_bus_mute(_sfx_bus)


func _on_FullscreenToggle_toggled(button_pressed):
	OS.window_fullscreen = button_pressed


func _on_MuteMusicToggle_toggled(button_pressed):
	AudioServer.set_bus_mute(_music_bus, button_pressed)


func _on_MuteSoundToggle_toggled(button_pressed):
	AudioServer.set_bus_mute(_sfx_bus, button_pressed)
