shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear;
uniform float blur_radius : hint_range(0.0, 20.0) = 5.0;
uniform float intensity : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 ps = SCREEN_PIXEL_SIZE;

    vec3 sum = vec3(0.0);
    // простое блюр-суммирование 9 сэмплов
    for (float x = -1.0; x <= 1.0; x += 1.0) {
        for (float y = -1.0; y <= 1.0; y += 1.0) {
            vec2 offset = vec2(x, y) * blur_radius * ps;
            sum += texture(SCREEN_TEXTURE, uv + offset).rgb;
        }
    }
    sum /= 9.0;

    vec3 orig = texture(SCREEN_TEXTURE, uv).rgb;
    vec3 glow = sum * intensity;

    COLOR = vec4(orig + glow, 1.0);
}
