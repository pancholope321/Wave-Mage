shader_type canvas_item;

uniform float skew_x = 0.3;
uniform float skew_y = 0.0;

void fragment() {
    // Create skew matrix
    mat2 skew_matrix = mat2(
        vec2(1.0, skew_y),
        vec2(skew_x, 1.0)
    );
    
    // Apply skew centered around middle
    vec2 centered_uv = UV - vec2(0.5);
    vec2 skewed_uv = (skew_matrix * centered_uv) + vec2(0.5);
    
    // Check bounds
    if (skewed_uv.x >= 0.0 && skewed_uv.x <= 1.0 && skewed_uv.y >= 0.0 && skewed_uv.y <= 1.0) {
        COLOR = texture(TEXTURE, skewed_uv);
    } else {
        COLOR = vec4(0.0);
    }
}