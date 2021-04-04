/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var cmp = new MyComponentText("Button", c_white, c_black);
cmp.move_text = true;
__uw_obj.AddComponent(cmp);
cmp = new MyComponentTooltip(50, 50, "Press button to show message", c_black);
cmp.w = 300;
__uw_obj.AddComponent(cmp);

image_speed = 0;
