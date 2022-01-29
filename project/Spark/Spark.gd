extends PathFollow2D

signal hit(player_index)

const UNIT_PER_SECOND := 0.05
const VERTICES := 16
const ROTATION_SPEED := 0.4

onready var _radius: float = $Area2D/CollisionShape2D.shape.radius

var _rotation_factor := 0.0
var _half_circle_a: PoolVector2Array
var _half_circle_b: PoolVector2Array


func _draw():
	draw_colored_polygon(_half_circle_a, Color.black)
	draw_colored_polygon(_half_circle_b, Color.white)
	#draw_circle(Vector2.ZERO, $Area2D/CollisionShape2D.shape.radius, Color.orange)


func _process(delta):
	unit_offset += UNIT_PER_SECOND * delta
	_half_circle_a = []
	_half_circle_b = []
	for i in VERTICES+1:
		_half_circle_a.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU+_rotation_factor))
	
	for i in VERTICES+1:
		_half_circle_b.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU+_rotation_factor+PI))
	
	_rotation_factor += ROTATION_SPEED
	update()


func _on_Area2D_body_entered(body):
	if body is Projectile:
		emit_signal("hit", body.player_index)
