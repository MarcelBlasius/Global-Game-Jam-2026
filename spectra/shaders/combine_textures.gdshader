shader_type canvas_item;

uniform sampler2D tex_left;
uniform sampler2D tex_right;
uniform sampler2D tex_alpha;


//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV;
	vec4 alpha = texture(tex_alpha, uv);
	
	if (alpha.x < 0.5) {
        // Left half → texture 1
        COLOR = texture(tex_left, uv);
    } else {
        // Right half → texture 2
        COLOR = texture(tex_right, uv);
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
