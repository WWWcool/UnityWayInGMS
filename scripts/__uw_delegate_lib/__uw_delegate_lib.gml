// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @returns {UWDelegate}

function UWDelegate() constructor
{
    list = [];
	
    /// @param {function} method_or_function
    /// @param {instance|struct} [context]
    
    static Add = function(method_or_function)
    {
        array_push(list, ComputeCell(method_or_function, argument_count > 1 ? argument[1] : "non-explicit"));
    }
    
    /// @param {function} method_or_function
    /// @param {instance|struct} [context]
    
    static Remove = function(method_or_function)
    {
        method_or_function = ComputeCell(method_or_function, argument_count > 1 ? argument[1] : "non-explicit");
        
        var size = array_length(list), cell;
        while(size--)
        {
            cell = list[size];
            if((cell.execute == method_or_function.execute) and (cell.context == method_or_function.context))
            {
                array_delete(list, size, 1);
                break;
            }
        }
    }
    
    /// @param {any} [argCall=undefined]
    
    static Run = function(argCall)
    {
        var size = array_length(list);
        if(size)
        {
            var copy = array_clone(list), cell, execute;
            for(var i = 0; i < size; i++)
            {
                cell = copy[i];
                execute = cell.execute;
                
                if(is_string(cell.context))
					execute(argCall);
                else
                    with (cell.context) execute(argCall);
            }
        }
    }
    
    static Clear = function()
    {
        list = [];
    }
    
    /// @param {function} method_or_function
    /// @param {instance|struct|string} context
    /// @returns {struct}
    
    static ComputeCell = function(method_or_function, context)
    {
        if(is_method(method_or_function))
            method_or_function = method_get_index(method_or_function);
        
        if(is_string(context))
            context = "context-non-explicit";
        else
        {
            if(is_undefined(argument[1]) or (is_real(argument[1]) and object_exists(argument[1])))
                context = "context-non";
            else
                context = argument[1];
        }
        
        return
        {
            context: context,
            execute: method_or_function
        }
    }
    
}
