extends KinematicBody2D
export var speed := 100.0

const RING_THICKNESS := 4.0
const SPAWN_LEFT := preload("res://Enemy/spawn_p1.wav")
const SPAWN_RIGHT := preload("res://Enemy/spawn_p2.wav")
const KILL_LEFT := preload("res://Enemy/kill_p1.wav")
const KILL_RIGHT := preload("res://Enemy/kill_p2.wav")

var target: KinematicBody2D setget _set_target

var _direction := Vector2.RIGHT
var _ring_color: Color
var _background_color: Color

onready var _radius: float = $CollisionShape2D.shape.radius
onready var _spawn_sound := $SpawnSound

func _physics_process(delta: float)->void:
	if not Globals.playing:
		return
	
	var angle_to_target = get_angle_to(target.get_global_transform().origin)
	rotation += angle_to_target
	
	var collision := move_and_collide((_direction * speed * delta).rotated(rotation))
	
	if collision != null:
		if collision.collider == target:
			target.damage()
			queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, _radius, _ring_color)
	draw_circle(Vector2.ZERO, _radius-RING_THICKNESS, _background_color)


func play_spawn_sound(left:bool)->void:
	_spawn_sound.stream = SPAWN_LEFT if left else SPAWN_RIGHT
	_spawn_sound.play()


func damage()->void:
	var explosion: CPUParticles2D = preload("res://Enemy/EnemyExplosion.tscn").instance()
	explosion.global_position = get_global_transform().origin
	explosion.one_shot = true
	# Using color as a proxy for player index is a kludge.
	explosion.sound = KILL_LEFT if _ring_color==Color.white else KILL_RIGHT
	get_parent().add_child(explosion)
	
	queue_free()


func _set_target(new_target: KinematicBody2D)->void:
	target = new_target
	var target_id: int = target.player_index
	
	collision_mask = 1 if target_id == 0 else 2
	
	_ring_color = Color.white if target_id == 0 else Color.black
	_background_color = Color.black if target_id == 0 else Color.white
