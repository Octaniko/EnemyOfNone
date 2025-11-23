shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

uniform vec4 color_dark : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 color_light : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float dither_repeat = 1.0;
uniform float dither_strength = 1.0;
uniform float min_dither_brightness = 0.1;

uniform int bayer_mode = 4;

void fragment() {
    vec4 tex = textureLod(screen_texture, SCREEN_UV, 0.0);
    vec3 color_in = tex.rgb;
    float brightness = dot(color_in, vec3(0.299, 0.587, 0.114));

    vec4 out_color;
    if (brightness < min_dither_brightness) {
        out_color = color_dark;
    } else {
        vec2 screen_px_size = SCREEN_PIXEL_SIZE;
        vec2 screen_res = vec2(1.0) / screen_px_size;
        vec2 pixel_coord = SCREEN_UV * screen_res / dither_repeat;

        float threshold = 0.0;
        if (bayer_mode == 4) {
            int x = int(floor(mod(pixel_coord.x, 4.0)));
            int y = int(floor(mod(pixel_coord.y, 4.0)));
            int index = y * 4 + x;
            float bayer4[16] = float[](
                0.0/16.0, 8.0/16.0, 2.0/16.0, 10.0/16.0,
                12.0/16.0, 4.0/16.0, 14.0/16.0, 6.0/16.0,
                3.0/16.0, 11.0/16.0, 1.0/16.0, 9.0/16.0,
                15.0/16.0, 7.0/16.0, 13.0/16.0, 5.0/16.0
            );
            threshold = bayer4[index];
        } else if (bayer_mode == 8) {
            int x = int(floor(mod(pixel_coord.x, 8.0)));
            int y = int(floor(mod(pixel_coord.y, 8.0)));
            int index = y * 8 + x;
            float bayer8[64] = float[](
                0.0/64.0, 32.0/64.0, 8.0/64.0, 40.0/64.0,
                2.0/64.0, 34.0/64.0, 10.0/64.0, 42.0/64.0,
                48.0/64.0, 16.0/64.0, 56.0/64.0, 24.0/64.0,
                50.0/64.0, 18.0/64.0, 58.0/64.0, 26.0/64.0,
                12.0/64.0, 44.0/64.0, 4.0/64.0, 36.0/64.0,
                14.0/64.0, 46.0/64.0, 6.0/64.0, 38.0/64.0,
                60.0/64.0, 28.0/64.0, 52.0/64.0, 20.0/64.0,
                62.0/64.0, 30.0/64.0, 54.0/64.0, 22.0/64.0,
                3.0/64.0, 35.0/64.0, 11.0/64.0, 43.0/64.0,
                1.0/64.0, 33.0/64.0, 9.0/64.0, 41.0/64.0,
                51.0/64.0, 19.0/64.0, 59.0/64.0, 27.0/64.0,
                49.0/64.0, 17.0/64.0, 57.0/64.0, 25.0/64.0,
                15.0/64.0, 47.0/64.0, 7.0/64.0, 39.0/64.0,
                13.0/64.0, 45.0/64.0, 5.0/64.0, 37.0/64.0,
                63.0/64.0, 31.0/64.0, 55.0/64.0, 23.0/64.0,
                61.0/64.0, 29.0/64.0, 53.0/64.0, 21.0/64.0
            );
            threshold = bayer8[index];
        }

        vec4 dithered = (brightness < threshold) ? color_dark : color_light;
        out_color = mix(tex, dithered, dither_strength);
    }

    COLOR = out_color;
}
