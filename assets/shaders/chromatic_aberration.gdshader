shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;

uniform float aberration_x : hint_range(-1.0, 1.0) = 0.04;
uniform float aberration_y : hint_range(-1.0, 1.0) = 0.04;
uniform float radius : hint_range(0.0, 1.0) = 0.5; // радиус круга без аберрации
uniform float edge_falloff : hint_range(0.0, 1.0) = 0.2; // плавность перехода

void fragment() {
    vec2 centered = SCREEN_UV - vec2(0.5);
    float dist = length(centered);
    float mask = smoothstep(radius, radius + edge_falloff, dist);

    vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 offset = vec2(aberration_x * pixel_size.x, aberration_y * pixel_size.y) * 100.0;

    vec3 col_r = texture(SCREEN_TEXTURE, SCREEN_UV + offset).rgb;
    vec3 col_g = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
    vec3 col_b = texture(SCREEN_TEXTURE, SCREEN_UV + offset).rgb;

    vec3 aberrated = vec3(col_r.r, col_g.g, col_b.b);
    vec3 original = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;

    COLOR.rgb = mix(original, aberrated, mask);
}
