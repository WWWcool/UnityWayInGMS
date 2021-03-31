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
	128,
	0,
	"Instances",
	__uw_o_transform_demo_child,
	child.id
);

angle = 0;

__uw_obj.transform.SetPositionAndAngleAndScale(
	__uw_obj.transform.position,
	__uw_obj.transform.angle,
	new UWVector2(1, 0.5)
);
