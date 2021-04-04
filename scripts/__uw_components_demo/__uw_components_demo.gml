// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

draw_set_font(__uw_f_components_demo);

// We want to responce on mouse and draw text for out btn

function MyComponentText(_text, _color, _color_on) : UWComponent(1 /*some uniq int id*/, "MyComponentText") constructor
{
	text = _text;
	color = _color;
	color_on = _color_on;
	
	move_text = false;
	if_mouse_on = false;
	
	static draw = function()
	{
		var c = if_mouse_on ? color_on : color;
		var shift_y = move_text && if_mouse_on ? 15 : 0;
		draw_set_valign(fa_center);
		draw_set_halign(fa_middle);
		draw_text_color(game_object.id.x, game_object.id.y + shift_y, text, c, c, c, c, 1);
	}
	
	static onMouseEnter = function()
	{
		if_mouse_on = true;
	}
	
	static onMouseLeave = function()
	{
		if_mouse_on = false;
	}
}

// We want to draw text tooltip near object when mouse on it

function MyComponentTooltip(_shift_x, _shift_y, _text, _color) : UWComponent(2 /*some uniq int id*/, "MyComponentTooltip") constructor
{
	shift_x = _shift_x;
	shift_y = _shift_y;
	text = _text;
	color = _color;
	w = 250;
	h = 100;
	
	if_mouse_on = false;
	
	static draw = function()
	{
		if(if_mouse_on)
		{
			var _x = game_object.id.x + shift_x;
			var _y = game_object.id.y + shift_y;
			
			draw_sprite_stretched(__uw_spr_components_demo_panel, 0, _x, _y, w, h);
			draw_set_valign(fa_center);
			draw_set_halign(fa_middle);
			draw_set_color(color);
			draw_text_ext(_x + w / 2, _y + h / 2, text, string_height(text) * 1.1, w * 0.8);
		}
	}
	
	static onMouseEnter = function()
	{
		if_mouse_on = true;
	}
	
	static onMouseLeave = function()
	{
		if_mouse_on = false;
	}
}

