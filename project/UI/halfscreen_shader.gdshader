shader_type canvas_item;

uniform vec3 left  = vec3(1.0);
uniform vec3 right = vec3(0.0);
uniform float x_offset = 0.0;

void fragment() {
	vec4 tex = texture(TEXTURE,UV);
	if (FRAGCOORD.x < 1.0/SCREEN_PIXEL_SIZE.x/2.0 + x_offset) {
		COLOR = vec4(left,tex.a);
	} else {
		COLOR = vec4(right,tex.a);
	}
}