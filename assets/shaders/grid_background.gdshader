shader_type canvas_item;

uniform vec4 bg_color : source_color = vec4(0.1, 0.137, 0.196, 1.0);
uniform vec4 line_color : source_color = vec4(0.07, 0.13, 0.176, 1.0);
uniform float cell_size : hint_range(20.0, 200.0) = 80.0;
uniform float line_thickness : hint_range(0.5, 4.0) = 1.0;
uniform float scroll_speed : hint_range(0.0, 50.0) = 8.0;
uniform float vignette_intensity : hint_range(0.0, 3.0) = 1.5;

void fragment() {
    vec2 pos = FRAGCOORD.xy;
    pos.y += TIME * scroll_speed;

    vec2 grid = mod(pos, cell_size);

    float line = step(grid.x, line_thickness) + step(grid.y, line_thickness);
    line = clamp(line, 0.0, 1.0);

    COLOR = mix(bg_color, line_color, line);

    vec2 uv = UV - 0.5;
    float vignette = 1.0 - dot(uv, uv) * vignette_intensity;
    COLOR.rgb *= clamp(vignette, 0.0, 1.0);
}