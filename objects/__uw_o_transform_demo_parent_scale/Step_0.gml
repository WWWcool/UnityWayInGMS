/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var dt = delta_time / 1000000;

child.__uw_obj.transform.SetLocalPositionAndAngleAndScale(
	child.__uw_obj.transform.local_position,
	child.__uw_obj.transform.local_angle - 60 * dt,
	child.__uw_obj.transform.local_scale
);

child2.__uw_obj.transform.SetLocalPositionAndAngleAndScale(
	child2.__uw_obj.transform.local_position,
	child2.__uw_obj.transform.local_angle + 360 * dt,
	child2.__uw_obj.transform.local_scale
);
