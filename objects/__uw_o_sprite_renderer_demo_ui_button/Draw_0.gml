/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

draw_set_font(__uw_f_transform_demo_ui);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(color);
draw_text_transformed(
	x + 70 * image_xscale,
	y + (20 + image_index * 3) * image_yscale,
	text,
	image_xscale,
	image_yscale,
	image_angle
);
