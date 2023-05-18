shader_type canvas_item;

uniform sampler2D pattern;
uniform float rotation_angle;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

void fragment() {
	vec2 rotated_uv = rotateUV(UV, vec2(0.5), rotation_angle);
	COLOR = texture(pattern, fract(rotated_uv * vec2(8, 7.2) + TIME / 16.0));
}

