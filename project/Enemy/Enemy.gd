extends KinematicBody2D
export var speed := 100.0

const RING_THICKNESS := 4.0
const PARTICLE_GRAVITY_SCALE := 100.0
const SPAWN_LEFT := preload("res://Enemy/spawn_p1.wav")
const SPAWN_RIGHT := preload("res://Enemy/spawn_p2.wav")
const KILL_LEFT := preload("res://Enemy/kill_p1.wav")
const KILL_RIGHT := preload("res://Enemy/kill_p2.wav")

var target: KinematicBody2D setget _set_target

var _direction := Vector2.RIGHT
var _ring_color: Color
var _is_on_left := false

onready var _radius: float = $CollisionShape2D.shape.radius-2 # half of the line width
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
	draw_arc(Vector2.ZERO, _radius, 0.0, TAU, 32, _ring_color, 4.0)


func play_spawn_sound(left:bool)->void:
	_spawn_sound.stream = SPAWN_LEFT if left else SPAWN_RIGHT
	_spawn_sound.play()


func damage()->void:
	var explosion: CPUParticles2D = preload("res://Enemy/EnemyExplosion.tscn").instance()
	explosion.global_position = get_global_transform().origin
	explosion.one_shot = true
	explosion.sound = KILL_LEFT if _is_on_left else KILL_RIGHT
	explosion.texture = Globals.circle_texture
	explosion.gravity = -_direction.rotated(rotation)*PARTICLE_GRAVITY_SCALE
	get_parent().add_child(explosion)
	
	queue_free()


func _set_target(new_target: KinematicBody2D)->void:
	target = new_target
	var target_id: int = target.player_index
	_is_on_left = true if target_id == 0 else false
	
	collision_mask = 1 if _is_on_left else 2
	
	_ring_color = Color.white if _is_on_left else Color.black
