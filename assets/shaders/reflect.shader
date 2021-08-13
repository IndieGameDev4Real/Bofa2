shader_type canvas_item;

uniform vec2 light_pos;
uniform vec2 cam_pos;

varying vec2 world_pos;

void vertex() {
	world_pos = ((PROJECTION_MATRIX * WORLD_MATRIX) * vec4(VERTEX, 0.0, 1.0) * inverse(PROJECTION_MATRIX)).xy;
}

void fragment() {
	vec2 diff = cam_pos - world_pos;
	
	COLOR = texture(SCREEN_TEXTURE, diff * SCREEN_PIXEL_SIZE);
	COLOR += texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR *= 0.5;

}