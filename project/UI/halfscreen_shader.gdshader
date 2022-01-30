shader_type canvas_item;

uniform vec3 left  = vec3(1.0);
uniform vec3 right = vec3(0.0);
uniform float barrier_x = 512.0;

void fragment() {
	vec4 tex = texture(TEXTURE,UV);
	if (FRAGCOORD.x<barrier_x) {
		COLOR = vec4(left,tex.a);
	} else {
		COLOR = vec4(right,tex.a);
	}
}