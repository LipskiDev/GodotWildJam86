shader_type spatial;
render_mode unshaded, depth_test_disabled;
stencil_mode read, compare_equal, 1;

void vertex() {
	POSITION = vec4(VERTEX.xy, 0.99, 1.0);
}

void fragment() {
	float aspect = VIEWPORT_SIZE.y / VIEWPORT_SIZE.x;
	ALBEDO = vec3(0.1, 0.2, 0.9) * 0.02;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
