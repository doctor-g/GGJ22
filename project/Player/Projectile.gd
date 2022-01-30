class_name Projectile
extends KinematicBody2D

const SPEED := 300.0
const PARTICLE_GRAVITY_SCALE := 90.0

var direction := Vector2.ZERO
var player_index := -1 setget _set_player_index

var _color: Color


func _ready():
	assert(player_index!=-1)


func _physics_process(delta):
	var collision := move_and_collide(direction*delta*SPEED)
	if collision!=null:
		if collision.collider.has_method("damage"):
			collision.collider.damage()
			
		# Check if we hit a wall, in which case, explode
		elif collision.collider is StaticBody2D:
			var explosion : CPUParticles2D = preload("res://Player/ProjectileExplosion.tscn").instance()
			get_parent().add_child(explosion)
			explosion.one_shot = true
			explosion.global_position = global_position
			explosion.gravity = direction * PARTICLE_GRAVITY_SCALE
			explosion.texture = Globals.circle_texture
		
		queue_free()


func _draw():
	draw_circle(Vector2.ZERO, $CollisionShape2D.shape.radius, _color)


func _set_player_index(index:int)->void:
	player_index = index
	_color = Color.white if index == 0 else Color.black
