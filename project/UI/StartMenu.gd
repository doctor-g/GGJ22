extends Control

onready var _play_button := $PlayButton
onready var _shadery_things := [$Title, $Background, $Label]

func _ready():
	_play_button.grab_focus()


func _process(_delta):
	var seconds := OS.get_ticks_msec() / 1000.0
	var x := range_lerp(sin(seconds), -1, 1, 412, 612)
	for control in _shadery_things:
		control.material.set_shader_param("barrier_x", x)


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")
