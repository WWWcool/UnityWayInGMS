/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

if(need_appear)
{
	var channel = animcurve_get_channel(__uw_a_transform_demo_ui_appear, 0);
	var lerp_val = animcurve_channel_evaluate(channel, anim_pos);
	var new_pos = target_pos.Lerp(start_pos, target_pos, lerp_val);
	anim_pos += anim_speed;
	if(anim_pos >= 1)
	{
		need_appear = false;
		new_pos = target_pos;
		anim_pos = 0;
	}
	__uw_obj.transform.SetPositionAndAngleAndScale(
		new_pos,
		__uw_obj.transform.angle,
		__uw_obj.transform.lossy_scale
	)
}

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

if(need_disappear)
{
	var channel = animcurve_get_channel(__uw_a_transform_demo_ui_disappear, 0);
	var scale = animcurve_channel_evaluate(channel, anim_pos);
	anim_pos += anim_speed;
	if(anim_pos >= 1)
	{
		need_disappear = false;
		scale = 0;
	}
	__uw_obj.transform.SetPositionAndAngleAndScale(
		__uw_obj.transform.position,
		__uw_obj.transform.angle,
		new UWVector2(scale, scale)
	)
}
