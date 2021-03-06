// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_OBJECT_NAME "__uw_obj"
#macro UW_BASE_NAME "UWObject"
#macro UW_COMPONENT_NAME "UWComponent"

#macro UW_COMPONENT_GROUP_CREATE "UWGroupCreate"
#macro UW_COMPONENT_GROUP_STEP "UWGroupStep"
#macro UW_COMPONENT_GROUP_DRAW "UWGroupDraw"

/// @desc Check if instance suitable for unity way
///
/// @param {object} _obj Instance id
/// @return {bool} check result

function __uw_check_instance(_obj)
{
    if(!instance_exists(_obj))
        return false;
    if(!variable_instance_exists(_obj, UW_OBJECT_NAME))
        return false;
    if(instanceof(_obj.__uw_obj) != UW_BASE_NAME)
        return false;
    return true;
}

/// @desc Base container for unity way logic
/// @param {object} [_obj] Instance id
/// @return {UWObject} created uw object

function UWObject() constructor
{
    id = noone;
    components = {};
    components_names = [];
    transform = noone;
    groups = {};
    groups_names = [];
    
    /// @desc Print all components and childs of object
    /// @param {number} _indent
    
    static ShowHierarchy = function(_indent)
    {
        var debug = new UWUtilsDebug("");
        var context =
        {
            debug : debug,
            indent : _indent
        }
        
        debug.PrintlnWithIndent(
            "object: " + string(id),
            context.indent
        );
        
        for(var i = 0; i < array_length(groups_names); i++)
        {
            debug.PrintlnWithIndent(
                "group: " + groups_names[i],
                context.indent
            );
            var group = groups[$ groups_names[i]];
            for(var k = 0; k < array_length(group.components); k++)
            {
                debug.PrintlnWithIndent(
                    "cmp: " + group.components[k].name,
                    context.indent
                );
            }
        }
        
        MapComponents(
            function(_cmp, _context)
            {
                _context.debug.PrintlnWithIndent(
                    "cmp: " + _cmp.name + " " + _cmp.GetInfo(),
                    _context.indent
                );
            },
            context
        );
        if(is_struct(transform))
        {
            transform.ForeachChild(
                function(_transform, _context)
                {
                    _transform.game_object.ShowHierarchy(_context.indent + 1);
                },
                context
            );
        }
    }
    
    /// @desc Link uw object to game object
    
    static LinkToInstance = function(_inst)
    {
        if(instance_exists(_inst))
        {
            id = _inst;
            if(is_struct(transform))
            {
                transform.SetInstance(_inst);
            }
        }
    }
    
    /// @desc Clear all components in object
    
    static Clear = function()
    {
        components = {};
        components_names = [];
        groups = {};
        groups_names = [];
    }
    
    /// @desc Add component to object
    /// @param {UWComponent} _cmp component to add
    /// @return {bool} result
    
    static AddComponent = function(_cmp)
    {
        if(!is_struct(_cmp))
            return false;
        if(components[$ _cmp.type_id] != undefined)
            return false;

        if(instanceof(_cmp) == UW_TRANSFORM_NAME)
        {
            transform = _cmp;
            var parent = transform.parent;
            // Create instance of all groups in parent object (need reinit this after relink parent)
            // TODO: use something like event to handle set new parent in transform cmp
            if(id == noone && parent != noone)
            {
                show_debug_message("Copy groups");
                var names = parent.game_object.groups_names;
                for(var i = 0; i < array_length(names); i++)
                {
                    var group = parent.game_object.groups[$ names[i]];
                    AddGroup(group.type, group.check_func, group.exec_func);
                }
            }
        }
        
        components[$ _cmp.type_id] = _cmp;
        components_names = variable_struct_get_names(components);
        _cmp.game_object = self;
        TryToAddToGroups(_cmp);
        return true;
    }
    
    /// @desc Remove component from object
    /// @param {UWComponent} _cmp component to remove
    /// @return {bool} result
    
    static RemoveComponent = function(_cmp)
    {
        if(!is_struct(_cmp))
            return false;
        if(components[$ _cmp.type_id] == undefined)
            return true;
            
        RemoveFromGroups(_cmp);
        variable_struct_remove(components, _cmp.type_id);
        components_names = variable_struct_get_names(components);
        return true;
    }
    
    /// @param {number} _type_id component type id
    /// @return {UWComponent} found component
    
    static GetComponentByTypeID = function(_type_id)
    {
        return components[$ _type_id] == undefined ? noone : components[$ _type_id];
    }
    
    /// @param {string} _name component name
    /// @return {UWComponent} found component
    
    static GetComponentByName = function(_name)
    {
        return FindComponent(
            function(_cmp, _name)
            { 
                return _cmp.name == _name;
            },
            _name
        );
    }
    
    /// @desc Trigger this function to emit create event for all components already added to object
    
    static CreateFinished = function()
    {
        ExecuteGroup(UW_COMPONENT_GROUP_CREATE);
    }
    
    /// @desc Add component group to object
    /// @param {string} _type index in object groups
    /// @param {script} _check_func function that check if component suitable for group
    /// @param {script} _exec_func function that do some work for group
    
    static AddGroup = function(_type, _check_func, _exec_func)
    {
        if(groups[$ _type] != undefined)
            return false;

        groups[$ _type] = new UWComponentGroup(_type, _check_func, _exec_func);
        groups_names = variable_struct_get_names(groups);
        MapComponents(
            function(_cmp, _group)
            {
                _group.TryAddComponent(_cmp);
            },
            groups[$ _type]
        );
        show_debug_message("AddGroup: " + _type);
        return true;
    }
    
    /// @param {UWComponent} _cmp component to add
    
    static TryToAddToGroups = function(_cmp)
    {
        for(var i = 0; i < array_length(groups_names); i++)
        {
            groups[$ groups_names[i]].TryAddComponent(_cmp);
        }
    }
    
    /// @param {UWComponent} _cmp component to remove
    
    static RemoveFromGroups = function(_cmp)
    {
        for(var i = 0; i < array_length(groups_names); i++)
        {
            groups[$ groups_names[i]].RemoveComponent(_cmp);
        }
    }
    
    /// @desc Execute all component that feat group
    /// @param {string} _type index in object groups
    /// @param {array} [_args] some args passed to exec function
    
    static ExecuteGroup = function(_type)
    {
        if(groups[$ _type] == undefined)
            return;
        
        if(argument_count > 1)
            groups[$ _type].Execute(argument[1]);
        else
            groups[$ _type].Execute();
            
        if(is_struct(transform))
        {
            transform.ForeachChild(
                function(_transform, _type)
                {
                    _transform.game_object.ExecuteGroup(_type);
                },
                _type
            );
        }
    }
    
    /// @desc Map all component with passed function and optional arguments
    /// @param _map_func
    /// @param _arg some args passed to function
    
    static MapComponents = function(_map_func)
    {
        if(argument_count > 1)
        {
            for(var i = 0; i < array_length(components_names); i++)
            {
                _map_func(components[$ components_names[i]], argument[1]);
            }
        }
        else
        {
            for(var i = 0; i < array_length(components_names); i++)
            {
                _map_func(components[$ components_names[i]]);
            }
        }
    }
    
    /// @desc Find component with passed find func
    /// @param _find_func
    /// @param _arg some args passed to function
    /// @return {UWComponent} found component
    
    static FindComponent = function(_find_func)
    {
        if(argument_count > 1)
        {
            for(var i = 0; i < array_length(components_names); i++)
            {
                var cmp = components[$ components_names[i]];
                if(_find_func(cmp, argument[1]))
                {
                    return cmp;
                }
            }
        }
        else
        {
            for(var i = 0; i < array_length(components_names); i++)
            {
                var cmp = components[$ components_names[i]];
                if(_find_func(cmp))
                {
                    return cmp;
                }
            }
        }
        
        return noone;
    }
}

/// @desc Base component for unity way logic
/// @param {number} _type_id component type id
/// @param {string} _name component name
/// @return {UWComponent} created component

function UWComponent(_type_id, _name) constructor
{
    type_id = _type_id;
    name = _name;
    game_object = noone;
    
    /// @desc Get info string specific for this component
    /// @return {string} info
    
    static GetInfo = function()
    {
        return "";
    }
    
    /// @desc Throw error if function is not implemented
    /// @param {string} _func_name name of not implemented function
    
    static throwNotImplemented = function(_func_name)
    {
        show_error(
            "Function - " + _func_name + 
            " of UWComponent: " + _name + " not implemented.",
            true
        )
    }
}

/// @desc Group components by some feature
/// @param {string} _type index in object groups
/// @param {script} _check_func function that check if component suitable for group
/// @param {script} _exec_func function that do some work for group
/// @return {UWComponentGroup} created component group

function UWComponentGroup(_type, _check_func, _exec_func) constructor
{
    type = _type;
    components = [];
    check_func = _check_func;
    exec_func = _exec_func;
    
    /// @desc Add component to group if it pass check
    /// @param {UWComponent} _cmp
    
    static TryAddComponent = function(_cmp)
    {
        if(check_func(_cmp))
        {
            array_push(components, _cmp);
        }
    }
    
    /// @desc Remove component from group
    /// @param {UWComponent} _cmp
    
    static RemoveComponent = function(_cmp)
    {
        for(var i = 0; i < array_length(components); i++)
        {
            if(_cmp == components[i])
            {
                array_delete(components, i, 1);
                break;
            }
        }
    }
	
    
    /// @desc Execute all component in group
    /// @param {array} [_args] some args passed to exec function
    
    static Execute = function()
    {
        if(argument_count > 0)
        {
            for(var i = 0; i < array_length(components); i++)
            {
                exec_func(components[i], argument[0]);
            }
        }
        else
        {
            for(var i = 0; i < array_length(components); i++)
            {
                exec_func(components[i]);
            }
        }
    }
}

