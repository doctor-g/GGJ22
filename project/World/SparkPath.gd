extends Path2D

const SIZE := Vector2(1024/2,600)
const POINTS := [
		Vector2.ZERO,
		Vector2(SIZE.x, 0),
		Vector2(SIZE.x, SIZE.y),
		Vector2(0, SIZE.y)
	]


func _ready():
	curve.clear_points()
	for point in POINTS:
		curve.add_point(point)

	# Close curve
	curve.add_point(POINTS[0])
