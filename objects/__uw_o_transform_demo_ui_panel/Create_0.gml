/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var shift_x = 26;
var shift_y = 32;

repeat(5)
{
	var inst = __uw_instance_create_layer(shift_x, shift_y, "Buttons", __uw_o_transform_demo_ui_button, id);	
	inst.text = "Button " + string(shift_y);
	shift_y += 50;
}

var apply = __uw_instance_create_layer(shift_x, shift_y + 24, "Buttons", __uw_o_transform_demo_ui_button_apply, id);
apply.text = "Apply";

mouse_start_pos = {};
start_pos = {};
