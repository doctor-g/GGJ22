extends Node

const _DIAMETER := 8.0
const _SMOOTHING_FACTOR := 1

var playing := true

var circle_texture := ImageTexture.new()


func _init():
	var circle_image = Image.new()
	circle_image.create(_DIAMETER, _DIAMETER, false, Image.FORMAT_RGBA8)
	circle_image.lock()
	for x in _DIAMETER:
		for y in _DIAMETER:
			if x*x +y*y - (_DIAMETER-1)*x - (_DIAMETER-1)*y + pow(_DIAMETER, 2)/2  <= pow(_DIAMETER, 2)/4 + _SMOOTHING_FACTOR:
				circle_image.set_pixel(x, y, Color.white)
			else:
				circle_image.set_pixel(x, y, Color(0, 0, 0, 0))
	circle_texture.create_from_image(circle_image, 4)

