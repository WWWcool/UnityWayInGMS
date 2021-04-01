/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();
draw_set_color(title_color);
draw_text_transformed(
	x + 140 * image_xscale,
	y + 40 * image_yscale,
	"Press to move it!",
	image_xscale,
	image_yscale,
	image_angle
);
