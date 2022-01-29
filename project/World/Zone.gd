extends Area2D


func _draw():
	draw_colored_polygon($CollisionPolygon2D.polygon, Color.black)
