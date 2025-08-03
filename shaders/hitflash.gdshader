shader_type canvas_item;

uniform vec4 hit_flash_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform bool hit_flash_on = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec3 final_rgb = hit_flash_on ? hit_flash_color.rgb : sprite_color.rgb;
	COLOR = vec4(final_rgb, sprite_color.a);
}
