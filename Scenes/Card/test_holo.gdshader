shader_type canvas_item;

uniform float speed : hint_range(0.0, 2.0) = 0.5;
uniform float frequency : hint_range(1.0, 10.0) = 2.0;
uniform float intensity : hint_range(0.0, 1.0) = 0.5;
uniform float shine_width : hint_range(0.0, 1.0) = 0.5;
uniform vec2 direction = vec2(1.0, 0.0);

// Function to create rainbow colors
vec3 hsvToRgb(float h, float s, float v) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(vec3(h) + K.xyz) * 6.0 - vec3(K.w));
    return v * mix(vec3(K.x), clamp(p - vec3(K.x), 0.0, 1.0), s);
}

void fragment() {
    // Sample the original texture
    vec4 original_color = texture(TEXTURE, UV);
    
    // Calculate the position for the shine effect
    vec2 normalized_dir = normalize(direction);
    float position = dot(UV, normalized_dir);
    
    // Create a moving shine effect
    float time_offset = TIME * speed;
    float shine = sin(position * frequency + time_offset) * 0.5 + 0.5;
    
    // Create a sharper shine with controlled width
    float sharp_shine = smoothstep(1.0 - shine_width, 1.0, shine) * intensity;
    
    // Generate rainbow colors based on position and time
    float hue = fract(position + time_offset * 0.1);
    vec3 rainbow = hsvToRgb(hue, 1.0, 1.0);
    
    // Apply the rainbow shine to the original texture
    vec3 final_color = mix(original_color.rgb, rainbow, sharp_shine * original_color.a);
    
    // Output the final color
    COLOR = vec4(final_color, original_color.a);
}