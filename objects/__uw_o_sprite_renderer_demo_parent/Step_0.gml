/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var dt = delta_time / 1000000;

__uw_obj.transform.SetPositionAndAngleAndScale(
	__uw_obj.transform.position,
	__uw_obj.transform.angle + 120 * dt,
	__uw_obj.transform.lossy_scale
);

child.transform.SetLocalPositionAndAngleAndScale(
	child.transform.local_position,
	child.transform.local_angle - 60 * dt,
	child.transform.local_scale
);

child2.transform.SetLocalPositionAndAngleAndScale(
	child2.transform.local_position,
	child2.transform.local_angle + 360 * dt,
	child2.transform.local_scale
);
