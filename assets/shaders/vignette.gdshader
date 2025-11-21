shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.0) = 0.5;
uniform float softness : hint_range(0.0, 1.0) = 0.3;
uniform float intensity : hint_range(0.0, 3.0) = 1.0;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 centered = uv - vec2(0.5);
    float dist = length(centered);
    float t = smoothstep(radius, radius + softness, dist);
    t = pow(t, 1.0);
    vec4 overlay = vignette_color;
    overlay.a = clamp(t * intensity, 0.0, 1.0);
    COLOR = overlay;
}
