// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @desc Struct for encapsulate debug utils functions
/// @param {string} [_prefix] start of each debug out
/// @return {UWUtilsDebug} created debug utils

function UWUtilsDebug() constructor
{
    prefix = argument[0] == undefined ? "" : argument[0] + " ";
    double_indent = false;
    
    /// @param {bool} _defined
    /// @param {string} _msg
    /// @param {array} [_args]
    
    static PrintlnIfDefined = function(_defined, _msg)
    {
        if(_defined)
            Println(_msg, argument_count > 2 ? argument[2] : []);
    }
    
    /// @param {string} _msg
    /// @param {array} [_args]
    
    static Println = function(_msg)
    {
        PrintlnWithIndent(_msg, 0, argument_count > 1 ? argument[1] : []);
    }
    
    /// @param {bool} _defined
    /// @param {string} _msg
    /// @param {number} _indent
    /// @param {array} [_args]
    
    static PrintlnWithIndentIfDefined = function(_defined, _msg, _indent, _args)
    {
        if(_defined)
            PrintlnWithIndent(_msg, _indent, argument_count > 3 ? argument[3] : []);
    }
    
    /// @param {string} _msg
    /// @param {number} _indent
    /// @param {array} [_args]
    
    static PrintlnWithIndent = function(_msg, _indent, _args)
    {
        show_debug_message(prefix + GetIndentString(double_indent ? 2 * _indent : _indent) + _msg);
    }
    
    /// @param {number} [_indent]
    /// @return {string} string with passed number of indent
    
    static GetIndentString = function(_indent)
	{
		var res = "";
		repeat(_indent)
		{
			res += "\t";
		}
		return res;
	}
}
