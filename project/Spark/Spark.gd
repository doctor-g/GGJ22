extends PathFollow2D

signal hit(player_index)

const UNIT_PER_SECOND := 0.2


func _draw():
	draw_circle(Vector2.ZERO, $Area2D/CollisionShape2D.shape.radius, Color.orange)


func _process(delta):
	unit_offset += UNIT_PER_SECOND * delta


func _on_Area2D_body_entered(body):
	if body is Projectile:
		emit_signal("hit", body.player_index)
