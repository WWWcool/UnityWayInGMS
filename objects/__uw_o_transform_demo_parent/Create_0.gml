/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var child = __uw_instance_create_layer(
	64,
	64,
	"Instances",
	__uw_o_transform_demo_child,
	id
);

var child2 = __uw_instance_create_layer(
	64,
	64,
	"Instances",
	__uw_o_transform_demo_child,
	child.id
);

__uw_obj.AddComponent(new UWLoop());
var interface = __uw_obj.GetComponentByName(UW_LOOP_NAME);