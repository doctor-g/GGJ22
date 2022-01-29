class_name Projectile
extends KinematicBody2D

const SPEED := 200.0

var direction := Vector2.ZERO
var player_index := -1 setget _set_player_index


func _ready():
	assert(player_index!=-1)


func _physics_process(delta):
	var collision := move_and_collide(direction*delta*SPEED)
	if collision!=null:
		if collision.collider.has_method("damage"):
			collision.collider.damage()
		queue_free()


func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.cyan)


func _set_player_index(index:int)->void:
	player_index = index
