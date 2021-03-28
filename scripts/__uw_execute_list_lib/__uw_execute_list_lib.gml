// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @returns {UWExecuteList} it is not delegate, it is execute list

function UWExecuteList() constructor
{
    list = [];
    bind = other;
    run = false;
    
    /// @param {instance|struct} _instance_or_struct
    /// @returns {UWExecuteList}
    
    static Bind = function(_instance_or_struct) 
    {
        CheckRuntime();
        bind = _instance_or_struct;
        
        CheckContext();
        return self;
    }
    
    /// @param {function} _method_or_function
    /// @param {any} _argContext
    
    static Add = function(_method_or_function, _argContext)
    {
        CheckRuntime();
        
        if(is_method(_method_or_function)) 
            _method_or_function = method_get_index(_method_or_function);
        
        var _cell =
        {
            execute: _method_or_function,
            argContext: _argContext
        }
            
        array_push(list, _cell);
    }
    
    static Remove = function(_method_or_function)
    {
        CheckRuntime();
        
        if(is_method(_method_or_function)) 
            _method_or_function = method_get_index(_method_or_function);
        
        var _size = array_length(list);
        while(_size--)
        {
            if(list[_size].execute == _method_or_function)
            {
                array_delete(list, _size, 1);
                break;
            }
        }
    }
    
    /// @returns {UWExecuteList}
    
    static Run = function(_argCall)
    {
        CheckRuntime();
        
        var _size = array_length(list);
        if(_size)
        {
            CheckContext();
            
            run = true;
            with (bind)
            {
                var _i = 0, _cell, _execute;
                do
                {
                    _cell = other.list[_i];
                    _execute = _cell.execute;
                    _execute(_argCall, _cell.argContext);
                } until (++_i == _size);
            }
            run = false;
        }
        return self;
    }
    
    /// @returns {function}
    
    static RunBuild = function()
    {
        CheckContext();
        return method(self, Run);
    }
    
    static Clear = function()
    {
        CheckRuntime();
        list = [];
    }
    
    static CheckContext = function()
    {
        if(is_struct(bind))
        {
            exit;
        }
        
        if(is_real(bind))
        {
            if(object_exists(bind))
            {
                throw ("[UWDelegate] you cannot use objects for binding: " + string(bind));
            }
            if(instance_exists(bind))
            {
                exit;
            }
        }
        throw ("[UWDelegate] You cannot bind a delegate to a non-existent object: " + string(bind));
    }
    
    static CheckRuntime = function()
    {
        if(run)
        {
            throw "[UWDelegate] You cannot use a deligate when processing its call list";
        }
    }
    
}
