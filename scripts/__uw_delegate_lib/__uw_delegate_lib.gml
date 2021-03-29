// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// A delegate is a type that represents method references with a specific parameter list. 
/// When you instantiate a delegate, that instance can be associated with any method with a compatible signature.
/// The method can be called (activated) using a delegate instance. 
/// @returns {UWDelegate} created delegate

function UWDelegate() constructor
{
    list = [];
    
    /// Associate method with this delegate
    /// @param {script | method} _method_or_function
    /// @param {instance | struct} _context
    
    static Add = function(_method_or_function, _context)
    {
        var cell =
        {
            ref: _method_or_function,
            context: _context,
            execute: method(_context, _method_or_function),
        }
        array_push(list, cell);
    }
    
    /// Dissociate method from this delegate
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
    
    /// Activate all methods associated with this delegate
    /// @param {any} [_args] args to pass to all methods
    
    static Run = function()
    {
        var size = array_length(list);
        if(size)
        {
            var copy = array_clone(list);
            for(var i = 0; i < size; i++)
            {
                if(argument_count > 0)
                {
                    copy[i].execute(argument[0]);
                }
                else
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
