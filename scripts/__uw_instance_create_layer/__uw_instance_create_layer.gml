/// Create instance with transform link to parent UWTransform
///
/// @param _x The x position the object will be created at
/// @param _y The y position the object will be created at
/// @param _layer_id_or_name The layer ID (or name) to assign the created instance to
/// @param _obj The object index of the object to create an instance of
/// @param _parent UWObject base instance or UWObject or UWTransform to link this instance to

function __uw_instance_create_layer(_x, _y, _layer_id_or_name, _obj, _parentOrInst)
{
    var _parent = noone;
    
	var _add_transform_func = function(_uw_obj)
    {
        var parent_transform = _uw_obj.GetComponentByTypeID(UW_TRANSFORM_TYPE_ID);
        if(parent_transform != noone)
        {
            return parent_transform;
        }
        else
        {
            var transform = new UWTransform(undefined, _uw_obj.id);
            _uw_obj.AddComponent(transform);
			_uw_obj.id.__uw_transform = transform;
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
	_inst.__uw_transform = transform;
	return _inst;
}
