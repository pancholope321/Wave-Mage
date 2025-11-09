shader_type canvas_item;

uniform vec2 origin = vec2(0.5, 0.5);
uniform float wave_speed = 2.0;
uniform float wave_frequency = 120.0;
uniform float min_alpha = 0.2;
uniform float max_alpha = 1.0;
uniform vec2 square_points[4];

// Function to check if a point is inside a quadrilateral using triangle decomposition
bool point_in_quadrilateral(vec2 p, vec2[4] quad) {
    // Split quadrilateral into two triangles and check if point is in either
    vec2 v0, v1, v2;

    // First triangle: points 0, 1, 2
    v0 = quad[1] - quad[0];
    v1 = quad[2] - quad[0];
    v2 = p - quad[0];

    float dot00 = dot(v0, v0);
    float dot01 = dot(v0, v1);
    float dot02 = dot(v0, v2);
    float dot11 = dot(v1, v1);
    float dot12 = dot(v1, v2);

    float inv_denom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * inv_denom;
    float v = (dot00 * dot12 - dot01 * dot02) * inv_denom;

    bool in_triangle1 = (u >= 0.0) && (v >= 0.0) && (u + v <= 1.0);

    // Second triangle: points 0, 2, 3
    v0 = quad[2] - quad[0];
    v1 = quad[3] - quad[0];
    v2 = p - quad[0];

    dot00 = dot(v0, v0);
    dot01 = dot(v0, v1);
    dot02 = dot(v0, v2);
    dot11 = dot(v1, v1);
    dot12 = dot(v1, v2);

    inv_denom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    u = (dot11 * dot02 - dot01 * dot12) * inv_denom;
    v = (dot00 * dot12 - dot01 * dot02) * inv_denom;

    bool in_triangle2 = (u >= 0.0) && (v >= 0.0) && (u + v <= 1.0);

    return in_triangle1 || in_triangle2;
}

void fragment() {
    vec2 uv = UV;

    // Check if point is in quadrilateral
    if (point_in_quadrilateral(uv, square_points)) {
        // Inside square - apply wave effect
        float dist = distance(uv, origin);
        float wave = sin(dist * wave_frequency - TIME * wave_speed);
        float alpha_wave = (wave + 1.0) * 0.5;
        float alpha = mix(min_alpha, max_alpha, alpha_wave);

        COLOR = vec4(COLOR.rgb, alpha);
    } else {
        // Outside square - transparent
        COLOR = vec4(0.0);
    }
}