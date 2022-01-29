extends Node2D

var polygon: PoolVector2Array
var color: Color
var aim_angle := 0.0 setget _set_aim_angle
var distance_to_reticle: float
var reticle_radius: float

func _draw():
	draw_colored_polygon(polygon, color)
	draw_circle(Vector2(distance_to_reticle, 0).rotated(aim_angle), reticle_radius, color)


func _set_aim_angle(value:float)->void:
	aim_angle = value
	update()
