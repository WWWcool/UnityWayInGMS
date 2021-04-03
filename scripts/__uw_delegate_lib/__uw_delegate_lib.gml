// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @desc A delegate is a type that represents method references with a specific parameter list. 
/// When you instantiate a delegate, that instance can be associated with any method with a compatible signature.
/// The method can be called (activated) using a delegate instance. 
/// @return {UWDelegate} created delegate

function UWDelegate() constructor
{
    list = [];
    
    /// @desc Associate method with this delegate
    /// @param {script | method} _method_or_function
    /// @param {instance | struct} _context
    
    static Add = function(_method_or_function, _context)
    {
        array_push(
            list,
            {
                ref: _method_or_function,
                context: _context,
                execute: method(_context, _method_or_function),
            }
        );
    }
    
    /// @desc Dissociate method from this delegate
    /// @param {script | method} _method_or_function
    /// @param {instance | struct} _context
    
    static Remove = function(_method_or_function, _context)
    {
        for(var i = array_length(list) - 1; i >= 0; i--)
        {
            var data = list[i];
            if((data.ref == _method_or_function) and (data.context == _context))
            {
                array_delete(list, i, 1);
                break;
            }
        }
    }
    
    /// @desc Activate all methods associated with this delegate
    /// @param {any} [_args] args to pass to all methods
    
    static Run = function()
    {
        var size = array_length(list);
        if(size)
        {
            var copy = array_clone(list);
            if(argument_count > 0)
            {
                for(var i = 0; i < size; i++)
                {
                    copy[i].execute(argument[0]);
                }
            }
            else
            {
                for(var i = 0; i < size; i++)
                {
                    copy[i].execute();
                }
            }
        }
    }
    
    static Clear = function()
    {
        list = [];
    }
}
