extends Node2D

var current_halo_radius := 0.0
var is_drawing := false


func _draw():
	if is_drawing:
		draw_arc(Vector2.ZERO, current_halo_radius, 0.0, TAU, 32, Color.white, 4)
