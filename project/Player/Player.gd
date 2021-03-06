extends KinematicBody2D

signal death

const VERTICES := 32
const RADIUS := 20
const DISTANCE_TO_RETICLE := 30
const RETICLE_RADIUS := 5
const SHOOT_P1 := preload("res://Player/shoot_p1.wav")
const SHOOT_P2 := preload("res://Player/shoot_p2.wav")
const DEATH_P1 := preload("res://Player/death_p1.wav")
const DEATH_P2 := preload("res://Player/death_p2.wav")

export(int,1) var player_index := 0
export var cooldown_time := 0.3

var speed := 150

var _aim_angle : float

var _move_left : String
var _move_right : String
var _move_up : String
var _move_down : String
var _aim_left: String
var _aim_right : String
var _aim_up : String
var _aim_down : String
var _fire : String
var _color : Color

var _can_shoot := true

onready var _collision_shape := $CollisionShape2D
onready var _cooldown_timer := $CooldownTimer
onready var _basic_shape := $BasicShape
onready var _shoot_sound := $ShootSound
onready var _death_sound := $DeathSound

func _ready():
	_configure_for_player_index()
	
	_basic_shape.reticle_radius = RETICLE_RADIUS
	_basic_shape.distance_to_reticle = DISTANCE_TO_RETICLE
	_basic_shape.radius = _collision_shape.shape.radius
	
	if player_index == 1:
		_aim_angle += PI
		_basic_shape.aim_angle = _aim_angle


func _physics_process(delta):
	if not Globals.playing:
		return
	else:
		_process_move_input(delta)
		_process_aim_input()
		_process_shoot_input()


func damage()->void:
	_death_sound.play()
	emit_signal("death")
	var explosion: CPUParticles2D = preload("res://Player/PlayerExplosion.tscn").instance()
	explosion.position = position
	explosion.texture = Globals.circle_texture
	get_parent().add_child(explosion)
	explosion.one_shot = true
	hide()


func show_halo()->void:
	$Halo.visible = true


func _is_any_aim_pressed()->bool:
	return Input.is_action_pressed(_aim_up) \
		or Input.is_action_pressed(_aim_down) \
		or Input.is_action_pressed(_aim_left) \
		or Input.is_action_pressed(_aim_right)


# Several fields depend on whether this is player 1 or player 2.
# This function sets those up.
func _configure_for_player_index():
	var suffix := "_p1" if player_index==0 else "_p2"
	_move_left = "move_left" + suffix
	_move_right = "move_right" + suffix
	_move_up = "move_up" + suffix
	_move_down = "move_down" + suffix
	_aim_left = "aim_left" + suffix
	_aim_right = "aim_right" + suffix
	_aim_up = "aim_up" + suffix
	_aim_down = "aim_down" + suffix
	_fire = "fire" + suffix
	
	_shoot_sound.stream = SHOOT_P1 if player_index==0 else SHOOT_P2
	_death_sound.stream = DEATH_P1 if player_index==0 else DEATH_P2
	
	_basic_shape.color = Color.white if player_index==0 else Color.black


func _process_move_input(delta:float)->void:
	var direction := Vector2(
		Input.get_axis(_move_left, _move_right),
		Input.get_axis(_move_up, _move_down)
	)
	var collision := move_and_collide(direction*delta*speed)
	if collision != null:
		damage()


func _process_aim_input()->void:
	if _is_any_aim_pressed():
		_aim_angle = Vector2(
			Input.get_axis(_aim_left, _aim_right), 
			Input.get_axis(_aim_up, _aim_down)
		).angle()
		
		_basic_shape.aim_angle = _aim_angle


func _process_shoot_input():
	if Input.is_action_pressed(_fire) and _can_shoot:
		_shoot()


func _shoot()->void:
	_shoot_sound.play()
	
	_can_shoot = false
	_cooldown_timer.start(cooldown_time)
	
	var projectile : Node2D = preload("res://Player/Projectile.tscn").instance()
	projectile.player_index = player_index
	get_parent().add_child(projectile)
	projectile.global_position = get_global_transform().origin + Vector2(DISTANCE_TO_RETICLE,0).rotated(_aim_angle)
	projectile.direction = Vector2(cos(_aim_angle), sin(_aim_angle))


func _on_CooldownTimer_timeout()->void:
	_can_shoot = true



