// Unity way library see link for documentation
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_OBJECT_NAME "__uw_obj"
#macro UW_BASE_NAME "UWObject"
#macro UW_COMPONENT_NAME "UWComponent"

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
/// @param {object} _obj Instance id
/// @returns {UWObject} created uw object

function UWObject(_obj) constructor
{
    id = _obj;
    components = {};
    components_names = [];
    
    /// Clear all components in object
    
    Clear = function()
    {
        components = {};
        components_names = [];
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
            
        components[$ _cmp.type_id] = _cmp;
        components_names = variable_struct_get_names(components);
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
        return findComponent(_type_id, function(_type_id, _cmp)
        { 
           return _cmp.type_id == _type_id;
        });
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
