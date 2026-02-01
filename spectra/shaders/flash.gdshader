shader_type canvas_item;

uniform bool active = false;
uniform vec4 flash_color = vec4(0.8, 0.5, 0.5, 1.0);
uniform float alpha = 1.0;
uniform float charge_ability = 0.0;

void fragment() {
	vec4 tint_color = texture(TEXTURE, UV);
	
	if (active) {
		tint_color.rgb *= flash_color.rgb;
	}
	
	tint_color.a = min(tint_color.a, alpha);

	if (charge_ability > 0.0)
	{
		tint_color.rgb += vec3(charge_ability, charge_ability, charge_ability);
	}
	

	COLOR = tint_color;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
