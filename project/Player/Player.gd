extends KinematicBody2D

const VERTICES := 32
const RADIUS := 20

export(int,1) var player_index := 0

var speed := 150
var polygon setget ,_get_polygon

var _move_left : String
var _move_right : String
var _move_up : String
var _move_down : String
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
	
	_color = Color.white if player_index==0 else Color.black
	

func _physics_process(delta):
	var direction := Vector2(
		Input.get_axis(_move_left, _move_right),
		Input.get_axis(_move_up, _move_down)
	)
	
	# warning-ignore:return_value_discarded
	move_and_collide(direction*delta*speed)


func _draw():
	draw_colored_polygon(_collision_polygon.polygon, _color)


# A utility to allow the world to access a copy of this node's outline
func _get_polygon()->PoolVector2Array:
	return _collision_polygon.polygon
