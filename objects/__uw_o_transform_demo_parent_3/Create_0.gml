/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

child = __uw_instance_create_layer(
	64,
	64,
	"Instances",
	__uw_o_transform_demo_child,
	id
);

child2 = __uw_instance_create_layer(
	64,
	64,
	"Instances",
	__uw_o_transform_demo_child,
	child.id
);

angle = 0;
