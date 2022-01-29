extends KinematicBody2D

const SPEED := 200.0

var direction := Vector2.ZERO
var player_index := -1 setget _set_player_index


func _ready():
	assert(player_index!=-1)


func _physics_process(delta):
	# warning-ignore:return_value_discarded
	move_and_collide(direction*delta*SPEED)


func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.yellow)


func _set_player_index(index:int)->void:
	player_index = index
	collision_layer = 4 if index==0 else 8
	collision_mask = 2 if index==0 else 1


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
