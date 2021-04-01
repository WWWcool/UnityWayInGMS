/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var shift_x = 80;
var shift_y = 80;


var inst = __uw_instance_create_layer(shift_x, shift_y, "Buttons", __uw_o_transform_demo_ui_button_yellow, id);
inst.text = "Yellow";
inst.color = make_color_rgb(171, 0, 44);
inst = __uw_instance_create_layer(shift_x, shift_y + 55, "Buttons", __uw_o_transform_demo_ui_button, id);
inst.text = "Blue";
inst.color = make_color_rgb(67, 45, 99);
inst = __uw_instance_create_layer(shift_x, shift_y + 110, "Buttons", __uw_o_transform_demo_ui_button_green, id);
inst.text = "Green";
inst.color = make_color_rgb(46, 81, 17);
inst = __uw_instance_create_layer(shift_x, shift_y + 165, "Buttons", __uw_o_transform_demo_ui_button_gray, id);
inst.text = "Gray";
inst.color = make_color_rgb(86, 86, 86);

mouse_start_pos = {};
start_pos = {};
title_color = make_color_rgb(232, 226, 179);
