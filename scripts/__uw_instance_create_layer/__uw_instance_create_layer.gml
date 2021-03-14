// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki
/// Create instance with transform link to parent UWTransform
///
/// @param {number} _x The x position the object will be created at
/// @param {number} _y The y position the object will be created at
/// @param {layer} _layer_id_or_name The layer ID (or name) to assign the created instance to
/// @param {object} _obj The object index of the object to create an instance of
/// @param {UWTransform} _parent UWObject base instance or UWObject or UWTransform to link this instance to
/// @returns {object} created instance

function __uw_instance_create_layer(_x, _y, _layer_id_or_name, _obj, _parentOrInst)
{
    var _parent = noone;
    
	var _add_transform_func = function(_uw_obj)
    {
        var transform = _uw_obj.transform;
        if(transform != noone)
        {
            return transform;
        }
        else
        {
            transform = new UWTransform(noone, _uw_obj.id);
            _uw_obj.AddComponent(transform);
            return transform;
        }
		return undefined;
    }
    
    if(is_struct(_parentOrInst))
    {
        if(instanceof(_parentOrInst) == UW_BASE_NAME)
        {
            _parent = _add_transform_func(_parentOrInst);
        }
        else
        {
            if(instanceof(_parentOrInst) != UW_TRANSFORM_NAME)
                return -1;
            
            _parent = _parentOrInst;   
        }
    }
    else
    {
        if(instance_exists(_parentOrInst))
        {
            if(!__uw_check_instance(_parentOrInst))
                return -1;
                
            _parent = _add_transform_func(_parentOrInst.__uw_obj);
        }
        else
        {
            return -1;
        }
    }
    
    var _inst = instance_create_layer(_x, _y, _layer_id_or_name, _obj);
    
    if(!instance_exists(_inst))
        return -1;
    if(!__uw_check_instance(_inst))
    {
        instance_destroy(_inst);
        return -1;
    }
    
    var transform = new UWTransform(_parent, _inst);
    _inst.__uw_obj.AddComponent(transform);
	return _inst;
}
