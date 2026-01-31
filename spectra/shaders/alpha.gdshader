shader_type canvas_item;


uniform vec2 point1;
uniform float radius1;
uniform float corona = 40;
uniform vec2 point2;
uniform float radius2;
uniform bool invertWorld;
//void vertex() {
	//// Called for every vertex the material is visible on.
//}

float calcDist(vec2 uv, vec2 point, float radius)
{
	return sqrt((uv.x - point.x) * (uv.x - point.x) + (uv.y - point.y) * (uv.y - point.y)) - radius;;
}

float calcAlpha(float dist)
{
	float minDist = -(corona / 2.0);
	float maxDist =  (corona / 2.0);
	float a;
	
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
	
	return a;
}


float unionSDF(float d1, float d2) {
    return min(d1, d2);
}

float intersectionSDF(float d1, float d2) {
    return max(d1, d2);
}

float differenceSDF(float d1, float d2) {
    return max(d1, -d2);
}

float smoothUnion(float d1, float d2, float k)
{
    // k > 0 controls blend radius
    float h = clamp(0.5 + 0.5 * (d2 - d1) / k, 0.0, 1.0);
    return mix(d2, d1, h) - k * h * (1.0 - h);
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV * vec2(640, 360);
	float dist1 = calcDist(uv, point1, radius1);
	float dist2 = calcDist(uv, point2, radius2);
	float distResult = smoothUnion(dist1, dist2, 50);
	
    float a = calcAlpha(distResult);
		
	if (invertWorld)
	{
		a = 1.0 - a;
	}
	
	COLOR = vec4(a, a, a, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
