extends Control

onready var _play_button := $CenterContainer/PlayButton


func _ready():
	_play_button.grab_focus()


func _on_PlayButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://World/World.tscn")
