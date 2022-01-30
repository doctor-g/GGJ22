extends Node2D

signal spawn_enemy()

const MAX_HALO_RADIUS := 50.0
const MIN_HALO_RADIUS := 8.0

var _halo_collapse_amount := 0.0


func _process(delta):
	_halo_collapse_amount += delta
	if _halo_collapse_amount >= 1:
		emit_signal("spawn_enemy")
		queue_free()
	update()

func _draw():
	var current_halo_radius: float = lerp(MAX_HALO_RADIUS, MIN_HALO_RADIUS, _halo_collapse_amount*_halo_collapse_amount)
	draw_arc(Vector2.ZERO, current_halo_radius, 0.0, TAU, 32, Color.white, 4)
