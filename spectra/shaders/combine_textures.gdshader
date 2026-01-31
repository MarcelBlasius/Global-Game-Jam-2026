shader_type canvas_item;

uniform sampler2D tex_left;
uniform sampler2D tex_right;
uniform sampler2D tex_alpha;

uniform float time;

//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = vec2(1, 1) - UV;
	//uv = vec2(uv.x + (sin(uv.x * 50.0) / 70.0) , uv.y + (cos(uv.y * 50.0) / 70.0));
	vec4 alpha = texture(tex_alpha, uv);
	
	
	 COLOR = (1.0 - alpha.x) * texture(tex_left, uv) + alpha.x * texture(tex_right, uv);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
