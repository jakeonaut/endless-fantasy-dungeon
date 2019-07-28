shader_type canvas_item;

void fragment() {
    vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
    
    float avg = (c.r + c.g + c.b) / 3.0;
    c.rgb = vec3(avg);

    COLOR.rgb = c;
}