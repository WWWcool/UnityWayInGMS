// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @returns {UWDelegate} it is not delegate, it is execute list

function UWDelegate() constructor
{
    list = [];
    
    /// @param {function} method_or_function
    
    static Add = function(method_or_function)
    {
        array_push(list, UnwrapMetod(method_or_function));
    }
    
    static Remove = function(method_or_function)
    {
        method_or_function = UnwrapMetod(method_or_function);
        
        var _size = array_length(list), _cell;
        while(_size--)
        {
            _cell = list[_size];
            if((_cell.execute == method_or_function.execute) and (_cell.context == method_or_function.context))
            {
                array_delete(list, _size, 1);
                break;
            }
        }
    }
    
    static Run = function(argCall)
    {
        var _size = array_length(list);
        if(_size)
        {
            var _copy = array_create(_size);
            for(var _i = 0; _i < _size; _i++)
                _copy[_i] = list[_i];
            
            var _cell, _execute;
            for(_i = 0; _i < _size; _i++)
            {
                _cell = _copy[_i];
                _execute = _cell.execute;
                
                if(is_undefined(_cell.context))
                {
                    with (other) _execute(argCall);
                }
                else
                {
                    with (_cell.context) _execute(argCall);
                }
            }
        }
    }
    
    static Clear = function()
    {
        list = [];
    }
    
    /// @returns {struct}
    
    static UnwrapMetod = function(method_or_function)
    {
        if(is_method(method_or_function))
        {
            return
            {
                context: method_get_self(method_or_function),
                execute: method_get_index(method_or_function)
            }
        }
        return
        {
            context: undefined,
            execute: method_or_function
        }
    }
    
}
