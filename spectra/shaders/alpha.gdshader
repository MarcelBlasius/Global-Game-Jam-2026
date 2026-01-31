shader_type canvas_item;


uniform vec2 point;
uniform float radius;
uniform float corona = 40;
//void vertex() {
	//// Called for every vertex the material is visible on.
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV * vec2(640, 360);
	float dist = sqrt((uv.x - point.x) * (uv.x - point.x) + (uv.y - point.y) * (uv.y - point.y));;
    float a = 1.0;
	float minDist = radius - (corona / 2.0);
	float maxDist = radius + (corona / 2.0);
	
	
	
    if (dist < minDist)
    {
        a = 0.0;
    }
	else if (dist < maxDist)
	{
		a = (dist - minDist) / (maxDist - minDist);
	}
	else
	{
		a = 1.0;
	}
		

   COLOR = vec4(a, a, a, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
