shader_type spatial;
render_mode unshaded, depth_test_disabled, cull_disabled;
stencil_mode read, compare_equal, 2;

uniform vec3 col1 = vec3(0.05, 0.6, 0.1);
uniform vec3 col2 = vec3(0.02, 0.3, 0.05);
uniform ivec2 size = ivec2(128, 128);

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
	//float size = 1.0;
	//ALBEDO = vec3(0.1, 0.9, 0.2) * 0.5;
	
	float total = floor(SCREEN_UV.x * float(size.x)) + floor(SCREEN_UV.y * float(size.y));
	bool isEven = abs(mod(total, 2.0)) < 0.001;
	
	if (isEven) {
		ALBEDO = col1;
	} else {
		ALBEDO = col2;
	}
	ALPHA = 0.1;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
