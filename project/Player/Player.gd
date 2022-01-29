extends KinematicBody2D

signal death

const VERTICES := 32
const RADIUS := 20
const DISTANCE_TO_RETICLE := 30
const RETICLE_RADIUS := 5

export(int,1) var player_index := 0

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

onready var _collision_polygon := $CollisionPolygon2D

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
	
	_color = Color.white if player_index==0 else Color.black
	

func _physics_process(delta):
	var direction := Vector2(
		Input.get_axis(_move_left, _move_right),
		Input.get_axis(_move_up, _move_down)
	)
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction*delta*speed)
	
	if _is_any_aim_pressed():
		_aim_angle = Vector2(
			Input.get_axis(_aim_left, _aim_right), 
			Input.get_axis(_aim_up, _aim_down)
		).angle()
		update()
		
	if Input.is_action_just_pressed(_fire):
		_shoot()


func damage()->void:
	emit_signal("death")


func _is_any_aim_pressed()->bool:
	return Input.is_action_pressed(_aim_up) \
		or Input.is_action_pressed(_aim_down) \
		or Input.is_action_pressed(_aim_left) \
		or Input.is_action_pressed(_aim_right)


func _shoot()->void:
	var projectile : Node2D = preload("res://Player/Projectile.tscn").instance()
	projectile.player_index = player_index	
	get_parent().add_child(projectile)
	projectile.position = get_global_transform().origin + Vector2(DISTANCE_TO_RETICLE,0).rotated(_aim_angle)
	projectile.direction = Vector2(cos(_aim_angle), sin(_aim_angle))


func _draw():
	draw_colored_polygon(_collision_polygon.polygon, _color)
	draw_circle(Vector2(DISTANCE_TO_RETICLE, 0).rotated(_aim_angle), RETICLE_RADIUS, _color)


# A utility to allow the world to access a copy of this node's outline
func _get_polygon()->PoolVector2Array:
	return _collision_polygon.polygon
