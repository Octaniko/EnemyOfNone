shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float ring_thickness : hint_range(0.01, 0.5) = 0.1;
uniform float ring_radius : hint_range(0.1, 0.9) = 0.4;
uniform vec4 progress_color : source_color = vec4(1.0, 0.5, 1.0, 1.0);
uniform vec4 background_color : source_color = vec4(0.2, 0.2, 0.2, 1.0);

void fragment() {
  vec2 uv = UV - vec2(0.5);
  float dist = length(uv);
  float angle = atan(uv.y, uv.x) + PI;
  float progress_angle = progress * 2.0 * PI;

  float outer = 1.0 - smoothstep(ring_radius + ring_thickness, ring_radius + ring_thickness + 0.01, dist);
  float inner = smoothstep(ring_radius, ring_radius + 0.01, dist);
  float ring = outer * inner;

  float mask = step(angle, progress_angle);

  vec4 col = mix(background_color, progress_color, mask);
  COLOR = vec4(col.rgb, col.a * ring);
}
