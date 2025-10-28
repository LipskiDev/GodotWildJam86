shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0);
uniform float number_of_tiles_x: hint_range(0.0, 64.0, 0.1);
uniform vec2 pixel_per_tile = vec2(16, 16);
uniform bool reverse = true;



void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
	vec2 number_of_tiles = vec2(number_of_tiles_x * ratio, number_of_tiles_x);
	vec2 uv = UV * number_of_tiles;

	vec2 pixel_pos = round(uv * pixel_per_tile);


	vec2 frac = fract(pixel_pos / pixel_per_tile);

	vec2 direction = abs(frac - 0.5);


	if (direction.x + direction.y + UV.x + UV.y >= progress * 4.0) {
		if(!reverse) {
			discard;
		}
	} else if(reverse) {
		discard;
	}
}