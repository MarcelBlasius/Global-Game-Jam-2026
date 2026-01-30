shader_type canvas_item;

uniform sampler2D tex_left;
uniform sampler2D tex_right;


//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	if (uv.x < 0.5) {
        // Left half → texture 1
        COLOR = texture(tex_left, vec2(uv.x * 2.0, uv.y));
    } else {
        // Right half → texture 2
        COLOR = texture(tex_right, vec2((uv.x - 0.5) * 2.0, uv.y));
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
