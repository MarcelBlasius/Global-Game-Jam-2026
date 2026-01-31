shader_type canvas_item;

uniform vec2 point;
uniform float radius;
//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV * vec2(640, 360);
	float sqDist = (uv.x - point.x) * (uv.x - point.x) + (uv.y - point.y) * (uv.y - point.y);;
    float a = 1.0;
	//float corona = 10.0 * 10.0;
    if (sqDist < radius * radius)
    {
        a = 0.0;
    }

   COLOR = vec4(a, a, a, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
