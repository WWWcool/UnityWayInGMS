/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event

event_inherited();

__uw_obj.AddComponent(new MyComponentText("Enter text...", c_white, c_green));
__uw_obj.AddComponent(new MyComponentTooltip(50, -37.5, "Press mouse to start enter. Press enter or mouse to end", c_black));

// reduce size of collision mask

image_xscale = 0.2;
image_yscale = 0.2;

started = false;
