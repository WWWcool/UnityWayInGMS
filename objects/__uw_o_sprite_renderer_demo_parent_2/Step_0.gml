/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var dt = delta_time / 1000000;

angle += 120 * dt;

child.transform.SetLocalPositionAndAngleAndScale(
	new UWVector2(128, 0).Mult(dsin(angle)),
	45 * dsin(2 * angle),
	child.transform.local_scale
);

child2.transform.SetLocalPositionAndAngleAndScale(
	child2.transform.local_position,
	child2.transform.local_angle + 360 * dt,
	child2.transform.local_scale
);
