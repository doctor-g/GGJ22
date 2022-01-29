extends PathFollow2D

const UNIT_PER_SECOND := 0.2


func _draw():
	draw_circle(Vector2.ZERO, $Area2D/CollisionShape2D.shape.radius, Color.orange)


func _process(delta):
	unit_offset += UNIT_PER_SECOND * delta


func damage():
	queue_free()


# If a body enters this, then by the masking policy, it should have been a 
# projectile
func _on_Area2D_body_entered(_body):
	damage()
