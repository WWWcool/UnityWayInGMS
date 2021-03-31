/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if(mouse_check_button(mb_left))
{
	if(mouse_check_button_pressed(mb_left))
	{
		mouse_start_pos = new UWVector2(mouse_x, mouse_y);
		start_pos = __uw_obj.transform.position;
	}
	else
	{
		__uw_obj.transform.SetPositionAndAngleAndScale(
			start_pos.Sub(mouse_start_pos.Sub(new UWVector2(mouse_x, mouse_y))),
			__uw_obj.transform.angle,
			__uw_obj.transform.lossy_scale
		)
	}
}
