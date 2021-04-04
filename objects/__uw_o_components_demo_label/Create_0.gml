/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event

event_inherited();

__uw_obj.AddComponent(new MyComponentText("Label", c_white, c_red));
__uw_obj.AddComponent(new MyComponentTooltip(50, -37.5, "Some more info about label", c_black));

// reduce size of collision mask

image_xscale = 0.2;
image_yscale = 0.2;
