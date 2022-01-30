extends PathFollow2D

signal hit(player_index)

const UNIT_PER_SECOND := 0.05
const VERTICES := 16
const ROTATION_SPEED := 4
const MAX_HALO_RADIUS := 50.0
const MIN_HALO_RADIUS := 18.0
const SOUND_P1 := preload("res://Spark/spark_p1.wav")
const SOUND_P2 := preload("res://Spark/spark_p2.wav")

onready var _radius: float = $Area2D/CollisionShape2D.shape.radius

var clockwise: bool

var _half_circle_a: PoolVector2Array
var _half_circle_b: PoolVector2Array
var _is_moving := true
var _halo_collapse_amount := 0.0

onready var _halo := $Area2D/Halo
onready var _hit_sound := $HitSound

func _ready():
	for i in VERTICES+1:
		_half_circle_a.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU))
	
	for i in VERTICES+1:
		_half_circle_b.append(Vector2(0,_radius).rotated(float(i)/VERTICES/2*TAU+PI))


func _draw():
	draw_colored_polygon(_half_circle_a, Color.black)
	draw_colored_polygon(_half_circle_b, Color.white)


func _process(delta):
	if _is_moving:
		unit_offset += UNIT_PER_SECOND * delta
		
		rotation += ROTATION_SPEED * delta * (1.0 if clockwise else -1.0)
	
	else:
		_halo_collapse_amount += delta
		_halo.current_halo_radius = lerp(MAX_HALO_RADIUS, MIN_HALO_RADIUS, 1-_halo_collapse_amount*_halo_collapse_amount)
		_halo.update()
		
		if _halo_collapse_amount >= 1.0:
			_set_is_moving(true)


func _on_Area2D_body_entered(body):
	if body is Projectile and _is_moving:
		_hit_sound.stream = SOUND_P1 if body.player_index==0 else SOUND_P2
		_hit_sound.play()
		
		emit_signal("hit", body.player_index)
		
		_set_is_moving(false)
		
		body.queue_free()


func _set_is_moving(new_value:bool)->void:
	_is_moving = new_value
	if new_value:
		_halo_collapse_amount = 0.0
	_halo.is_drawing = !new_value


func _get_is_moving()->bool:
	return _is_moving
