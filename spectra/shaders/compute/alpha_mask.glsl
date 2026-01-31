#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 0, binding = 0, rgba8) uniform restrict writeonly image2D out_tex;

layout(push_constant, std430) uniform Params {
    vec2 point;
    float radius;
} params;

void main() {
    ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
    ivec2 size = imageSize(out_tex);

    if (uv.x >= size.x || uv.y >= size.y)
        return;

    float sqDist = (uv.x - params.point.x) * (uv.x - params.point.x) + (uv.y - params.point.y) * (uv.y - params.point.y);
    float a = 1;
    if (sqDist < params.radius * params.radius)
    {
        float a = 0;
    }

    imageStore(out_tex, uv, vec4(a, a, a, a));
}