/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var parent_transform = new UWTransform(noone, id);
__uw_obj.AddComponent(parent_transform);

var create_button = function(_x, _y, _sprite, _text, _color, _parent, _action)
{
	var child = new UWObject();
	var transform = new UWTransform(_parent);
	child.AddComponent(transform);
	var sprite_renderer = new UWSpriteRenderer(_sprite);
	child.AddComponent(sprite_renderer);

	child.transform.SetLocalPositionAndAngleAndScale(
		new UWVector2(_x, _y),
		0,
		new UWVector2(1, 1)
	);
	
	var size = new UWVector2(sprite_get_width(_sprite), sprite_get_height(_sprite));
	
	var text = new MySpriteRendererText(size, _text, _color, _color);
	child.AddComponent(text);
	if(_text != "")
	{
		text.move_text = true;	
	}
	var button = new MySpriteRendererButton(size, _action, sprite_renderer);
	child.AddComponent(button);
	return child;
}

var shift_x = 80;
var shift_y = 80;

create_button(shift_x, shift_y, __uw_spr_sprite_renderer_demo_ui_button_yellow, "Yellow", make_color_rgb(171, 0, 44), parent_transform, function(){});
create_button(shift_x, shift_y + 55, __uw_spr_sprite_renderer_demo_ui_button_blue, "Blue", make_color_rgb(67, 45, 99), parent_transform, function(){});
create_button(shift_x, shift_y + 110, __uw_spr_sprite_renderer_demo_ui_button_green, "Green", make_color_rgb(46, 81, 17), parent_transform, function(){});
create_button(shift_x, shift_y + 165, __uw_spr_sprite_renderer_demo_ui_button_gray, "Gray", make_color_rgb(86, 86, 86), parent_transform, function(){});

var close = create_button(235, 25, __uw_spr_sprite_renderer_demo_ui_close, "", c_white, parent_transform, method(id, function(){need_disappear = true;}));

mouse_start_pos = {};
start_pos = {};
title_color = make_color_rgb(232, 226, 179);
need_appear = true;
need_disappear = false;
anim_pos = 0;
anim_speed = 0.015;

target_pos = new UWVector2(x, y);
start_pos = new UWVector2(x, y - 500);

__uw_obj.transform.SetPositionAndAngleAndScale(
	start_pos,
	__uw_obj.transform.angle,
	__uw_obj.transform.lossy_scale
)
