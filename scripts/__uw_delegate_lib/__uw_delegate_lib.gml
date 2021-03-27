// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @param {number} [_size] stack size
/// @returns {UWDelegate}

function UWDelegate(_size) constructor
{
    stack = [];
    limit = infinity;
    bind = undefined;
    run = false;
    
    /// @param {object|instance|struct|void} _instance_or_struct
    /// @returns {UWDelegate}
    
    static Bind = function(_instance_or_struct) 
    {
        RuntimeError();
        
        if(is_undefined(_instance_or_struct))
        {
            bind = undefined;
            return self;
        }
        
        if(CheckContext(_instance_or_struct) != "error")
        {
            bind = _instance_or_struct;
            return self;
        }
        
        ContextError(_instance_or_struct);
    }
    
    /// @returns {bool}
    
    static IsCanAdd = function() 
    {
        return (array_length(stack) < limit);
    }
    
    /// @param {function} _method_or_function
    /// @param {any} _argument
    /// @returns {bool}
    
    static Add = function(_method_or_function, _argument)
    {
        RuntimeError();
        
        if(!IsCanAdd()) 
            return false;
        
        if(is_method(_method_or_function)) 
            _method_or_function = method_get_index(_method_or_function);
        
        var _cell =
        {
            execute: _method_or_function,
            arg: _argument
        }
        
        array_push(stack, _cell);
        return true;
    }
    
    static Run = function() 
    {
        RuntimeError();
        
        var _size = array_length(stack);
        if(_size)
        {
            var _context = bind;
            
            if(argument_count > 0)
                _context = argument[0];
            
            if(_context == undefined) 
                _context = other;
            else
            {
                if(CheckContext(_context) == "error") ContextError(_context);
            }
            
            run = true;
            with (_context)
            {
                var _i = 0, _cell;
                do
                {
                    _cell = stack[_i];
                    _cell.execute(_cell.arg) break;
                } until (++_i == _size);
            }
            run = false;
        }
        return self;
    }
    
    static Clear = function()
    {
        RuntimeError();
        stack = [];
    }
    
    static RemoveFromBegin = function(_count)
    {
        RuntimeError();
        
        var _size = CountRemove(_count);
        if(_size)
        {
            array_delete(stack, 0, _count);
        }
    }
    
    static RemoveFromEnd = function(_count)
    {
        RuntimeError();
        
        var _size = CountRemove(_count);
        if(_size)
        {
            array_resize(stack, array_length(stack) - _count);
        }
    }
    
    static LimitResize = function(_newsize) 
    {
        RuntimeError();
        
        if(is_real(_newsize))
        {
            limit = (is_nan(_newsize) ? 1 : max(_newsize, 1));
        }
    }
    
    static CheckContext = function(_context)
    {
        if(is_struct(_context))
        {
            return "struct";
        }
        
        if(is_real(_context))
        {
            if(instance_exists(_instance_or_struct))
            {
                return "instance";
            }
        }
        return "error";
    }
    
    static CountRemove = function(_count)
    {
        if(is_real(_count))
        {
            if(is_nan(_count))
                return 0;
            
            return clamp(_count, 0, array_length(stack));
        }
        return 0;
    }
    
    static ContextError = function(_context)
    {
        var _error = new UWUtilsError(self);
        _error.AddText("You cannot bind a delegate to a non-existent object: ").AddArgument(_context);
        _error.Show();
    }
    
    static RuntimeError = function()
    {
        if(run)
        {
            var _error = new UWUtilsError(self);
            _error.AddText("You cannot use a deligate when processing its call stack");
            _error.Show();
        }
    }
    
    if(!is_undefined(_size)) LimitResize(_size);
}
