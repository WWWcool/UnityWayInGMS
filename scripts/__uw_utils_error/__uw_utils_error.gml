// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki


/// Struct for error generate
/// @param {struct<T>|string} [_type] type of error
/// @returns {UWUtilsError} created error utils

function UWUtilsError(_type) constructor
{
	type = "unknown";
	text = "";
	tab_count = 1;
	tab_switch = false;
	
	static prefix = "[UnityWay Error]";
	static symbol_control = (function() {
		var map = {};
		map[$ "\n"] = "\\n";
		map[$ "\t"] = "\\t";
		map[$ "\\"] = "\\\\";
		return map;
	}());
	
	/// @param {struct<T>|string} type
	
	static SetType = function(_component)
	{
		if is_string(_component) 
		{
			type = _component;
			exit;
		}
		if is_struct(_component) {
			type = instanceof(_component);
			exit;
		}
		type = "unknown";
	}
	
	/// @param {any} ...values
	/// @returns {UWUtilsError}
	
	static AddText = function() 
	{
		TabInsert();
		
		var _text = "";
		var _i = -1;
		while (++_i < argument_count) 
			_text += RemoveSymbolControl(argument[_i]);
		
		text += _text;
		return self;
	}
	
	/// @param {any} argument
	/// @returns {UWUtilsError}
	
	static AddArgument = function(_argument)
	{	
		TabInsert();
		
		if(is_bool(_argument))
		{
			text += (_argument ? "true" : "false");
			return self;
		}
		
		if(is_string(_argument))
		{
			text += "\"" + RemoveSymbolControl(_argument) + "\"";
			return self;
		}
		
		text += RemoveSymbolControl(_argument);
		return self;
	}
	
	/// @returns {UWUtilsError}
	
	static AddNewline = function()
	{
		text += "\n";
		tab_switch = false;
		return self;
	}
	
	/// @returns {UWUtilsError}
	
	static TabLeft = function() 
	{
		tab_count = max(1, tab_count - 1);
		return self;
	}
	
	/// @returns {UWUtilsError}
	
	static TabRight = function() 
	{
		tab_count += 1;
		return self;
	}
	
	/// @returns {bool}
	
	static TabInsert = function()
	{
		if(!tab_switch) 
		{
			text += string_repeat(" ", tab_count * 4);
			return true;
		}
		
		tab_switch = true;
		return false;
	}
	
	static Show = function()
	{
		show_error(Render(), true);
	}
	
	/// @returns {string}
	
	static Render = function()
	{
		var _stars = string_repeat("*", 48);
		return 
			(
				" " + prefix + " : " + type + "\n" +
				_stars + "\n" +
				text + "\n\n" +
				_stars
			);
	}
	
	/// @param {any} any
	/// @returns {string}
	
	static RemoveSymbolControl = function(_text)
	{
		if(!is_string(_text))
			_text = string(_text);
		
		var _length = string_length(_text);
		if _length
		{
			var _textModify = "";
			var _i = 1, _char, _charControl;
			do
			{
				_char = string_char_at(_text, _i);
				_charControl = symbol_control[$ _char];
				
				if(!is_undefined(_charControl))
					_char = _charControl;
				
				_textModify += _char;
			} until (_i++ == _length);
			return _textModify;
		}
		return "";
	}
	
	if!(is_undefined(_type)) SetType(_type);
	
}