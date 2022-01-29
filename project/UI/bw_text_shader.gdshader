shader_type canvas_item;

uniform float barrier_x = 512.0;

void fragment() {
	vec4 tex = texture(TEXTURE,UV);
	if (FRAGCOORD.x<barrier_x) {
		COLOR = vec4(0.0,0.0,0.0,tex.a);
	} else {
		COLOR = vec4(1.0,1.0,1.0,tex.a);
	}
}