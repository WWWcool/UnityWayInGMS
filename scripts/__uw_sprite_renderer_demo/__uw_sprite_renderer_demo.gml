// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

draw_set_font(__uw_f_components_demo);

// We want to responce on mouse and draw text for out btn

function MySpriteRendererText(_size, _text, _color, _color_on) : UWComponent(10 /*some uniq int id*/, "MySpriteRendererText") constructor
{
	size = _size;
	text = _text;
	color = _color;
	color_on = _color_on;
	
	move_text = false;
	text_height = string_height(_text);
	if_mouse_on = false;
	
	static draw = function()
	{
		var c = if_mouse_on ? color_on : color;
		var shift_y = move_text && if_mouse_on ? 4 : 0;
		var position = game_object.transform.position;
		var scale = game_object.transform.lossy_scale;
		draw_set_valign(fa_center);
		draw_set_halign(fa_middle);
		draw_text_ext_transformed_color(
			position.x + size.x * scale.x / 2,
			position.y + (size.y / 2 + shift_y) * scale.y,
			text,
			text_height,
			size.x * 0.9,
			scale.x,
			scale.y,
			game_object.transform.angle,
			c, c, c, c,
			1
		);
	}
	
	static step = function()
	{
		if_mouse_on = point_in_rectangle(
			mouse_x,
			mouse_y,
			game_object.transform.position.x,
			game_object.transform.position.y,
			game_object.transform.position.x + size.x,
			game_object.transform.position.y + size.y,
		);
	}
}

// We want to some object react as button

function MySpriteRendererButton(_size, _action, _sprite_renderer) : UWComponent(20 /*some uniq int id*/, "MySpriteRendererButton") constructor
{
	size = _size;
	action = _action;
	sprite_renderer = _sprite_renderer;
	
	if_mouse_on = false;
	
	static step = function()
	{
		if_mouse_on = point_in_rectangle(
			mouse_x,
			mouse_y,
			game_object.transform.position.x,
			game_object.transform.position.y,
			game_object.transform.position.x + size.x,
			game_object.transform.position.y + size.y,
		);
		
		sprite_renderer.subimg = if_mouse_on ? 1 : 0;
		
		if(mouse_check_button_pressed(mb_left) && if_mouse_on)
		{
			action();
		}
	}
}
