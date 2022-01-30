extends Control

onready var _play_button := $VBoxContainer/PlayButton
onready var _options_button := $VBoxContainer/OptionsButton
onready var _quit_button := $VBoxContainer/QuitButton
onready var _options_dialog := $OptionsDialog
onready var _shadery_things := [$Title, $Background, $Label]

func _ready():
	_play_button.grab_focus()
	Jukebox.play_title()
	
	# Only show quit button on non-HTML builds
	_quit_button.visible = OS.get_name() != "HTML5"


func _process(_delta):
	var seconds := OS.get_ticks_msec() / 1000.0
	var x := range_lerp(cos(seconds), -1, 1, 412, 612)
	for control in _shadery_things:
		control.material.set_shader_param("barrier_x", x)


func _on_PlayButton_pressed():
	Jukebox.play_theme()
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit(0)


func _on_OptionsButton_pressed():
	_options_dialog.show()


func _on_OptionsDialog_hide():
	_options_button.grab_focus()
