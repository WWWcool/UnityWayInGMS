/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();


if(target_angle != image_angle)
{
	var angle = lerp(image_angle, target_angle, angle_speed);
	__uw_obj.transform.SetLocalPositionAndAngleAndScale(
		__uw_obj.transform.local_position,
		angle,
		__uw_obj.transform.local_scale
	)
}
