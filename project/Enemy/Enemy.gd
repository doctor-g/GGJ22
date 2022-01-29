extends KinematicBody2D
# signals

# enums

# constants

# exported variables
export var speed := 100.0

# public variables
var target: KinematicBody2D setget _set_target

# private variables
var _direction := Vector2.RIGHT

# onready variables


func _physics_process(delta: float)->void:
	var angle_to_target = get_angle_to(target.get_global_transform().origin)
	rotation += angle_to_target
	
	var collision := move_and_collide((_direction * speed * delta).rotated(rotation))
	
	if collision != null:
		if collision.collider == target:
			target.damage()
			queue_free()


func _draw()->void:
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, Color.red)


func damage()->void:
	queue_free()


func _set_target(new_target: KinematicBody2D)->void:
	target = new_target
	var target_id: int = target.player_index
	
	collision_mask = 1 if target_id == 0 else 2
