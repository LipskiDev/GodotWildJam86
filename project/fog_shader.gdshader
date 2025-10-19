shader_type spatial;
render_mode unshaded, blend_mix, cull_disabled;

uniform sampler2D noise_tex : source_color; // Plug a seamless NoiseTexture2D or baked fog PNG

// Motion & look
uniform vec2 scroll_dir1 = vec2(1.0, 0.0);
uniform vec2 scroll_dir2 = vec2(-0.35, 1.0);
uniform float speed1 = 0.08;
uniform float speed2 = 0.03;
uniform float scale1 = 1.6;    // big shapes
uniform float scale2 = 4.0;    // fine detail
uniform float distortion = 0.12;
uniform float contrast = 1.1;  // >1 = punchier fog
uniform float intensity = 1.0; // overall opacity
uniform vec2 uv_repeat = vec2(2.0, 1.0); // tile amount across the plane

// “Portal” shaping (fade at the edges)
uniform float edge_fade = 0.15;        // left/right fade (0–0.5)
uniform float top_bottom_fade = 0.05;  // top/bottom fade (0–0.5)

// Color
uniform vec4 fog_tint : source_color = vec4(0.9, 0.95, 1.0, 1.0); // slightly bluish

void fragment() {
    vec2 base_uv = UV * uv_repeat;

    float t = TIME;

    // Distortion sample
    vec2 d_uv = base_uv * 0.5 + vec2(t * 0.03, -t * 0.02);
    float d = texture(noise_tex, d_uv).r;
    vec2 warp = vec2(d - 0.5) * distortion; // <-- fixed: make it vec2

    // Layered scrolling noise
    vec2 uv1 = base_uv * scale1 + warp + scroll_dir1 * t * speed1;
    vec2 uv2 = base_uv * scale2 - warp + scroll_dir2 * t * speed2;

    float n1 = texture(noise_tex, uv1).r;
    float n2 = texture(noise_tex, uv2).r;

    float fog = n1 * 0.6 + n2 * 0.4;
    fog = pow(clamp(fog * contrast, 0.0, 1.0), 1.1);

    // Soft “wall” mask so it’s densest in the center of the plane
    float x = abs(UV.x - 0.5);
    float y = abs(UV.y - 0.5);
    float edge_mask_x = smoothstep(0.5, 0.5 - edge_fade, x);
    float edge_mask_y = smoothstep(0.5, 0.5 - top_bottom_fade, y);
    float portal_mask = 1.0 - max(edge_mask_x, edge_mask_y);

    float alpha = clamp(fog * portal_mask * intensity, 0.0, 1.0);

    // Subtle center brightening (sells the magical seam)
    float center_glow = 1.0 - smoothstep(0.0, 0.35, length(UV - vec2(0.5)));
    vec3 col = fog_tint.rgb * (0.6 + 0.4 * center_glow);

    ALBEDO = col;
    ALPHA  = alpha;
}

