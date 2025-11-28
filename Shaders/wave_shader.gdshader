shader_type canvas_item;

uniform vec2 origin = vec2(0.5, 0.5);
uniform float wave_speed = 2.0;
uniform float wave_frequency = 120.0;
uniform float min_alpha = 0.2;
uniform float max_alpha = 1.0;
uniform vec2 triangle_points[3];
uniform float inner_radius = -0.1;
uniform float outer_radius = 0.0;
uniform vec4 color = vec4(1,1,1,1);

void fragment() {
    vec2 uv = UV;

    // Simple triangle check using barycentric coordinates
    vec2 v0 = triangle_points[1] - triangle_points[0];
    vec2 v1 = triangle_points[2] - triangle_points[0];
    vec2 v2 = uv - triangle_points[0];

    float dot00 = dot(v0, v0);
    float dot01 = dot(v0, v1);
    float dot02 = dot(v0, v2);
    float dot11 = dot(v1, v1);
    float dot12 = dot(v1, v2);

    float inv_denom = 1.0 / (dot00 * dot11 - dot01 * dot01);
    float u = (dot11 * dot02 - dot01 * dot12) * inv_denom;
    float v = (dot00 * dot12 - dot01 * dot02) * inv_denom;

    // Check if point is in triangle
    if ((u >= 0.0) && (v >= 0.0) && (u + v <= 1.0)) {
        // Inside triangle - calculate distance from origin
        float dist = distance(uv, origin);

        // Check if distance is within the adjustable band
        if (dist >= inner_radius && dist <= outer_radius) {
            // Within the band - apply wave effect
            float wave = sin(dist * wave_frequency - TIME * wave_speed);
            float alpha_wave = (wave + 1.0) * 0.5;
            float alpha = mix(min_alpha, max_alpha, alpha_wave);

            COLOR = vec4(color.rgb, alpha);
        } else {
            // Outside the band - transparent
            COLOR = vec4(0.0);
        }
    } else {
        // Outside triangle - transparent
        COLOR = vec4(0.0);
    }
}