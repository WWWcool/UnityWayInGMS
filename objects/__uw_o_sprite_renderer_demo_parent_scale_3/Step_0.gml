/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var dt = delta_time / 1000000;

angle += 120 * dt;

child.transform.SetLocalPositionAndAngleAndScale(
	new UWVector2(0, 128).Mult(dsin(angle)),
	child.transform.local_angle,
	child.transform.local_scale
);

child2.transform.SetLocalPositionAndAngleAndScale(
	new UWVector2(0, 128).Mult(dsin(angle)),
	child2.transform.local_angle + 360 * dt,
	child2.transform.local_scale
);
