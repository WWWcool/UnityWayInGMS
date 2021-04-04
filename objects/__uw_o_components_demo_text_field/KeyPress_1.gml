/// @description Insert description here
// You can write your code in this editor

if(started)
{
	if(keyboard_lastkey != vk_enter)
	{
		var cmp = __uw_obj.GetComponentByTypeID(1);
		cmp.text = keyboard_string;
	}
	else
	{
		started = false;
	}
}
