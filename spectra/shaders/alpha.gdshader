shader_type canvas_item;

uniform float posValues[20]; // position  and radius packed together in 4 values
uniform int value_count;

uniform float corona = 40;
uniform bool invert_world;
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

float smoothIntersection(float d1, float d2, float k)
{
    float h = clamp(0.5 - 0.5 * (d2 - d1) / k, 0.0, 1.0);
    return mix(d2, d1, h) + k * h * (1.0 - h);
}

float smoothDifference(float d1, float d2, float k)
{
    float h = clamp(0.5 - 0.5 * (d2 + d1) / k, 0.0, 1.0);
    return mix(d2, -d1, h) + k * h * (1.0 - h);
}

bool getWorldBit(float posBit, bool world_invert)
{
	if (world_invert)
	{
		return posBit != 1.0;
	}
	
	return posBit == 1.0;
}

//float calcDistResult(vec2 uv, vec2, point, float radius, float distResult)
//{
	//for(int i = 0; i< value_count; i++)
	//{
		//int index = i * 4;
		//bool worldBit = getWorldBit(posValues[index + 3], invert_world);
		//if (worldBit)
		//{
			//continue;
		//}
		//
		//vec2 point = vec2(posValues[index], posValues[index +1]);
		//float radius = posValues[index + 2];
		//
		//float dist = calcDist(uv, point, radius);
//
		//distResult = smoothUnion(distResult, dist, 50);
		////distResult = unionSDF(distResult, dist);
	//}
	//
//}

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV * vec2(640, 360);
	float distResult = 9999999.0;
	for(int i = 0; i< value_count; i++)
	{
		int index = i * 4;
		//bool worldBit = getWorldBit(posValues[index + 3], invert_world);
		bool worldBit = posValues[index + 3] == 1.0;
		if (worldBit)
		{
			continue;
			vec2 point = vec2(posValues[index], posValues[index +1]);
			float radius = posValues[index + 2];
			
			float dist = calcDist(uv, point, radius);

			dist *= 1.0;
			float union = smoothUnion(distResult, dist, 50);
			//float union = unionSDF(distResult, dist);
			//float intersection = intersectionSDF(distResult, dist);
			//distResult = differenceSDF(union, intersection);
			float intersection = smoothIntersection(distResult, dist, 20);
			distResult = differenceSDF(union, intersection);
		}
		else
		{
			vec2 point = vec2(posValues[index], posValues[index +1]);
			float radius = posValues[index + 2];
			
			float dist = calcDist(uv, point, radius);

			distResult = smoothUnion(distResult, dist, 50);
			//distResult = unionSDF(distResult, dist);
		}
		
		
	}
	
	for(int i = 0; i< value_count; i++)
	{
		int index = i * 4;
		bool worldBit = posValues[index + 3] == 1.0; //getWorldBit(posValues[index + 3], invert_world);
		if (worldBit)
		{
			vec2 point = vec2(posValues[index], posValues[index +1]);
			float radius = posValues[index + 2];
			
			float dist = calcDist(uv, point, radius);

			dist *= 1.0;
			float union = smoothUnion(distResult, dist, 50);
			//float union = unionSDF(distResult, dist);
			//float intersection = intersectionSDF(distResult, dist);
			//distResult = differenceSDF(union, intersection);
			float intersection = smoothIntersection(distResult, dist, 20);
			distResult = differenceSDF(union, intersection);
		}
		else
		{
			continue;
			vec2 point = vec2(posValues[index], posValues[index +1]);
			float radius = posValues[index + 2];
			
			float dist = calcDist(uv, point, radius);

			distResult = smoothUnion(distResult, dist, 50);
			//distResult = unionSDF(distResult, dist);
		}
	}

    float a = calcAlpha(distResult);
		
	if (invert_world)
	{
		a = 1.0 - a;
	}
	
	COLOR = vec4(a, a, a, 1);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
