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
export var cooldown_time := 0.5

var speed := 150
var polygon setget ,_get_polygon

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

onready var _collision_polygon := $CollisionPolygon2D
onready var _cooldown_timer := $CooldownTimer
onready var _basic_shape := $BasicShape
onready var _shoot_sound := $ShootSound
onready var _death_sound := $DeathSound

func _ready():
	var points : PoolVector2Array = []
	points.resize(VERTICES)
	for i in VERTICES+1:
		points.append(Vector2(0,RADIUS).rotated(float(i)/VERTICES*TAU))
	_collision_polygon.set_polygon(points)
	
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
	_basic_shape.reticle_radius = RETICLE_RADIUS
	_basic_shape.distance_to_reticle = DISTANCE_TO_RETICLE
	_basic_shape.polygon = _collision_polygon.polygon

func _physics_process(delta):
	if not Globals.playing:
		return
	
	var direction := Vector2(
		Input.get_axis(_move_left, _move_right),
		Input.get_axis(_move_up, _move_down)
	)
	
	var collision := move_and_collide(direction*delta*speed)
	if collision != null:
		damage()
	
	if _is_any_aim_pressed():
		_aim_angle = Vector2(
			Input.get_axis(_aim_left, _aim_right), 
			Input.get_axis(_aim_up, _aim_down)
		).angle()
		
		_basic_shape.aim_angle = _aim_angle
	
	if Input.is_action_just_pressed(_fire) and _can_shoot:
		_shoot()


func damage()->void:
	_death_sound.play()
	emit_signal("death")
	var explosion: CPUParticles2D = preload("res://Player/PlayerExplosion.tscn").instance()
	explosion.position = position
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


func _shoot()->void:
	_shoot_sound.play()
	
	_can_shoot = false
	_cooldown_timer.start(cooldown_time)
	
	var projectile : Node2D = preload("res://Player/Projectile.tscn").instance()
	projectile.player_index = player_index
	get_parent().add_child(projectile)
	projectile.global_position = get_global_transform().origin + Vector2(DISTANCE_TO_RETICLE,0).rotated(_aim_angle)
	projectile.direction = Vector2(cos(_aim_angle), sin(_aim_angle))


# A utility to allow the world to access a copy of this node's outline
func _get_polygon()->PoolVector2Array:
	return _collision_polygon.polygon


func _on_CooldownTimer_timeout()->void:
	_can_shoot = true



