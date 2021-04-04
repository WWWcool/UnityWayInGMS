/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event

event_inherited();

__uw_obj.AddComponent(new MyComponentText("Enter text...", c_white, c_green));
var cmp = new MyComponentTooltip(70, -37.5, "Press mouse to start enter. Press enter or mouse to end", c_black);
cmp.w = 300;
cmp.h = 150;
__uw_obj.AddComponent(cmp);

// reduce size of collision mask

image_xscale = 0.2;
image_yscale = 0.2;

started = false;
