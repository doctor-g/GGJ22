extends Node2D

onready var _player1 := $Players/Player1
onready var _player2 := $Players/Player2
onready var _zone := $Polygon2D

func _physics_process(_delta):
	if _player1_hit_boundary():
		print("Player 1 out!")
	if _player2_hit_boundary():
		print("Player 2 out!")


func _player1_hit_boundary() -> bool:
	var world_coords := _compute_world_coordinates(_player1)
	var array := Geometry.clip_polygons_2d(world_coords, _zone.polygon)
	return array.size() != 0


func _player2_hit_boundary() -> bool:
	var world_coords := _compute_world_coordinates(_player2)
	var array := Geometry.intersect_polygons_2d(world_coords, _zone.polygon)
	return array.size() != 0


func _compute_world_coordinates(node:Node2D) -> PoolVector2Array:
	var world_coords : PoolVector2Array = []
	for point in node.polygon:
		world_coords.append(point + node.position)
	return world_coords
