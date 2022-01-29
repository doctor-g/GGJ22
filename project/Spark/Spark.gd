extends PathFollow2D

signal hit(player_index)

const UNIT_PER_SECOND := 0.05
const VERTICES := 16
const ROTATION_SPEED := 0.4

onready var _radius: float = $Area2D/CollisionShape2D.shape.radius

var _half_circle_a: PoolVector2Array
var _half_circle_b: PoolVector2Array


func _ready():
	for i in VERTICES+1:
		_half_circle_a.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU))
	
	for i in VERTICES+1:
		_half_circle_b.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU+PI))


func _draw():
	draw_colored_polygon(_half_circle_a, Color.black)
	draw_colored_polygon(_half_circle_b, Color.white)


func _process(delta):
	unit_offset += UNIT_PER_SECOND * delta
	
	rotation += ROTATION_SPEED
	update()


func _on_Area2D_body_entered(body):
	if body is Projectile:
		emit_signal("hit", body.player_index)
		
		var explosion:CPUParticles2D = preload("res://Spark/SparkExplosion.tscn").instance()
		explosion.position = position
		get_parent().add_child(explosion)
		explosion.emitting = true
