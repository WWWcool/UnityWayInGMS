/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var cmp = new MyComponentText("Button", c_white, c_black);
cmp.move_text = true;
__uw_obj.AddComponent(cmp);

__uw_obj.AddComponent(new MyComponentTooltip(50, 50, "Press button to show debug message", c_black));

image_speed = 0;
