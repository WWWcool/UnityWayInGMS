// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_OBJECT_NAME "__uw_obj"
#macro UW_BASE_NAME "UWObject"
#macro UW_COMPONENT_NAME "UWComponent"

#macro UW_COMPONENT_GROUP_CREATE "UWGroupCreate"
#macro UW_COMPONENT_GROUP_STEP "UWGroupStep"
#macro UW_COMPONENT_GROUP_DRAW "UWGroupDraw"

/// Check if instance suitable for unity way
///
/// @param {object} _obj Instance id
/// @returns {bool} check result

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

/// Base container for unity way logic
/// @param {object} [_obj] Instance id
/// @returns {UWObject} created uw object

function UWObject() constructor
{
    id = noone;
    components = {};
    components_names = [];
    transform = noone;
    groups = {};
    groups_names = [];
    
    /// Link uw object to game object
    
    LinkToInstance = function(_inst)
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
    
    /// Clear all components in object
    
    Clear = function()
    {
        components = {};
        components_names = [];
        groups = {};
        groups_names = [];
    }
    
    /// Add component to object
    /// @param {UWComponent} _cmp component to add
    /// @returns {bool} result
    
    AddComponent = function(_cmp)
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
                var names = parent.game_object.groups_names;
                for(var i = 0; i < array_length(names); i++)
                {
                    groups[$ names[i]] = parent.game_object.groups[$ names[i]].CreateInstance();
                }
            }
        }
        
        components[$ _cmp.type_id] = _cmp;
        components_names = variable_struct_get_names(components);
        _cmp.game_object = self;
        return true;
    }
    
    /// Remove component from object
    /// @param {UWComponent} _cmp component to remove
    /// @returns {bool} result
    
    RemoveComponent = function(_cmp)
    {
        if(!is_struct(_cmp))
            return false;
        if(components[$ _cmp.type_id] == undefined)
            return true;
            
        variable_struct_remove(components, _cmp.type_id);
        components_names = variable_struct_get_names(components);
        return true;
    }
    
    /// @param {number} _type_id component type id
    /// @returns {UWComponent} found component
    
    GetComponentByTypeID = function(_type_id)
    {
        return components[$ _type_id] == undefined ? noone : components[$ _type_id];
    }
    
    /// @param {string} _name component name
    /// @returns {UWComponent} found component
    
    GetComponentByName = function(_name)
    {
        return findComponent(_name, function(_name, _cmp)
        { 
            return _cmp.name == _name;
        });
    }
    
    /// Trigger this function to emit create event for all components already added to object
    
    CreateFinished = function()
    {
        ExecuteGroup(UW_COMPONENT_GROUP_CREATE);
    }
    
    /// Add component group to object
    /// @param {string} _type index in object groups
    /// @param {script} _check_func function that check if component suitable for group
    /// @param {script} _exec_func function that do some work for group
    
    AddGroup = function(_type, _check_func, _exec_func)
    {
        if(groups[$ _type] != undefined)
            return false;

        groups[$ _type] = new UWComponentGroup(_type, _check_func, _exec_func);
        groups_names = variable_struct_get_names(groups);
        return true;
    }
    
    /// @param {UWComponent} _cmp component to add
    
    TryToAddToGroups = function(_cmp)
    {
        for(var i = 0; i < array_length(groups_names); i++)
        {
            groups[$ groups_names[i]].TryAddComponent(_cmp);
        }
    }
    
    /// @param {UWComponent} _cmp component to remove
    
    RemoveFromGroups = function(_cmp)
    {
        for(var i = 0; i < array_length(groups_names); i++)
        {
            groups[$ groups_names[i]].RemoveComponent(_cmp);
        }
    }
    
    /// Execute all component that feat group
    /// @param {string} _type index in object groups
    /// @param {array} [_args] some args passed to exec function
    
    ExecuteGroup = function(_type)
    {
        if(groups[$ _type] == undefined)
            return;
        
        if(argument_count > 1)
            groups[$ _type].Execute(argument[1]);
        else
            groups[$ _type].Execute();
    }
    
    // private section
    
    mapComponents = function(_map_action)
    {
    	for(var i = 0; i < array_length(components_names); i++)
        {
            _map_action(components[$ components_names[i]]);
        }
    }
    
    findComponent = function(_arg, _find_func)
    {
        for(var i = 0; i < array_length(components_names); i++)
        {
            var cmp = components[$ components_names[i]];
            if(_find_func(_arg, cmp))
            {
                return cmp;
            }
        }
        return noone;
    }
}

/// Base component for unity way logic
/// @param {number} _type_id component type id
/// @param {string} _name component name
/// @returns {UWComponent} created component

function UWComponent(_type_id, _name) constructor
{
    type_id = _type_id;
    name = _name;
    game_object = noone;
    
    /// Throw error if function is not implemented
    /// @param {string} _func_name name of not implemented function
    
    throwNotImplemented = function(_func_name)
    {
        show_error(
            "Function - " + _func_name + 
            " of UWComponent: " + _name + " not implemented.",
            true
        )
    }
}

/// Group components by some feature
/// @param {string} _type index in object groups
/// @param {script} _check_func function that check if component suitable for group
/// @param {script} _exec_func function that do some work for group
/// @returns {UWComponentGroup} created component group

function UWComponentGroup(_type, _check_func, _exec_func) constructor
{
    type = _type;
    components = [];
    check_func = _check_func;
    exec_func = _exec_func;
    
    /// Add component to group if it pass check
    /// @param {UWComponent} _cmp
    
    TryAddComponent = function(_cmp)
    {
        if(check_func(_cmp))
        {
            array_push(components, _cmp);
        }
    }
    
    /// Remove component from group
    /// @param {UWComponent} _cmp
    
    RemoveComponent = function(_cmp)
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
    
    /// Execute all component in group
    /// @param {array} [_args] some args passed to exec function
    
    Execute = function()
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
    
    /// Create instance of this group, use this to duplicate parent groups to child and trigger them
    /// @returns {UWComponentGroup} created group

    CreateInstance = function()
    {
        return new UWComponentGroup(type, check_func, exec_func);
    }
}

