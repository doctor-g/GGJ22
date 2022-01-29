extends AudioStreamPlayer

const TITLE := preload("res://Shared/title.ogg")
const THEME := preload("res://Shared/theme.ogg")

func play_theme():
	stream = THEME
	play()
	
func play_title():
	stream = TITLE
	play()
