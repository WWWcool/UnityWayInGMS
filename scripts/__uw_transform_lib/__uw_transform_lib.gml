// Unity way library see link for documentation
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_TRANSFORM_TYPE_ID 10001
#macro UW_TRANSFORM_NAME "UWTransform"
#macro UW_TRANSFORM_DEFINED true
#macro UW_TRANSFORM_VERSION 1

/// Position, rotation and scale of an object.
/// @param {UWTransform} [_parent]
/// @param {object} [_obj] Instance of an object if we want transform control it
/// @returns {UWTransform} created transform

function UWTransform() : UWComponent(UW_TRANSFORM_TYPE_ID, UW_TRANSFORM_NAME) constructor
{
    position = new UWVector2(0, 0);
    local_position = new UWVector2(0, 0);
    angle = 0;
    local_angle = 0;
    lossy_scale = new UWVector2(1, 1);
    local_scale = new UWVector2(1, 1);
    parent = noone;
    childs = [];
    childCount = function(){return array_length(childs)};
    instance = noone;
    
	/***
		*** SEE LATE INIT AT THE END OF THIS FILE ***
	***/
	
    /// Set the parent of the transform.
    ///
    /// @param {UWTransform} _transform
    /// @param {bool} [_world_position_stays]
    
    SetParent = function(_transform)
    {
        var _world_position_stays = argument[1] == undefined ? true : argument[1];
        if(_transform != noone)
        {
            if(_world_position_stays)
            {
                local_position = _transform.InverseTransformVector(position);
                local_angle = _transform.InverseTransformDirection(angle);
                local_scale = _transform.InverseTransformScale(lossy_scale);
            }
            else
            {
                SetPositionAndAngleAndScale(
                    _transform.TransformVector(local_position),
                    _transform.TransformDirection(local_angle),
                    _transform.TransformScale(local_scale)
                );
            }
        }
        else
        {
            if(_world_position_stays)
            {
                local_position = position;
                local_angle = angle;
                local_scale = lossy_scale;
            }
            else
            {
                SetPositionAndAngleAndScale(local_position, local_angle, local_scale);
            }
        }
        
        if(parent != noone)
        {
            for(var i = 0; i < parent.childCount(); i++)
            {
                if(parent.childs[i] == self)
                {
                    array_delete(parent.childs, i, 1);
                    break;
                }
            }
        }
        
        parent = _transform;
        
        if(parent != noone)
        {
            array_push(parent.childs, self);
        }
    }
    
    /// Sets the world space position, angle and scale of the Transform component.
    ///
    /// @param {UWVector2} _position
    /// @param {number} _angle
    /// @param {UWVector2} _scale
    
    SetPositionAndAngleAndScale = function(_position, _angle, _scale)
    {
        position = _position;
        angle = _angle;
        lossy_scale = _scale;
        with(instance)
        {
            x = _position.x;
            y = _position.y;
            image_xscale = _scale.x;
            image_yscale = _scale.y;
            image_angle = _angle;
        }
        foreachChild(function(_child)
        {
            _child.SetPositionAndAngleAndScale
            (
                TransformVector(_child.local_position),
                TransformDirection(_child.local_angle),
                TransformScale(_child.local_scale)
            );
        });
    }
    
    /// Moves the transform in the direction and distance of translation.
    ///
    /// @param {UWVector2} _translation
    /// @param {UWTransform} _relativeTo
    
    Translate = function(_translation, _relativeTo)
    {
        throwNotImplemented("Translate");
    }
    
    /// Rotates the object around by the number of degrees defined by the given angle.
    ///
    /// @param {UWVector2} _angle
    /// @param {UWTransform} _relativeTo
    
    Rotate = function(_angle, _relativeTo)
    {
        throwNotImplemented("Rotate");
    }
    
    /// Rotates the transform so the forward vector points at target's current position.
    ///
    /// @param {UWTransform} _target
    
    LookAt = function(_target)
    {
        throwNotImplemented("LookAt");
    }
    
    /// Transforms direction from local space to world space.
    ///
    /// @param {number} _direction
    /// @returns {number} world space direction
    
    TransformDirection = function(_direction)
    {
        return _direction + angle;
    }
    
    /// Transforms a direction from world space to local space.
    ///
    /// @param {number} _direction
    /// @returns {number} local space direction
    
    InverseTransformDirection = function(_direction)
    {
        return _direction - angle;
    }
    
    /// Transforms scale from local space to world space.
    ///
    /// @param {UWVector2} _scale
    /// @returns {UWVector2} world space scale
    
    TransformScale = function(_scale)
    {
        return _scale.Mult(lossy_scale);
    }
    
    /// Transforms scale from world space to local space.
    ///
    /// @param {UWVector2} _scale
    /// @returns {UWVector2} local space scale
    
    InverseTransformScale = function(_scale)
    {
        return _scale.Div(lossy_scale);
    }
    
    /// Transforms vector from local space to world space.
    ///
    /// @param {UWVector2} _vector
    /// @returns {UWVector2} world space vector
    
    TransformVector = function(_vector)
    {
        var world_x = lossy_scale.x * (
            _vector.x * dcos(-angle) -
            _vector.y * dsin(-angle)
        ) + position.x;
        var world_y = lossy_scale.y * (
            _vector.x * dsin(-angle) +
            _vector.y * dcos(-angle)
        ) + position.y;
        
        return new UWVector2(world_x, world_y);
    }
    
    /// Transforms vector from world space to local space.
    ///
    /// @param {UWVector2} _vector
    /// @returns {UWVector2} local space vector
    
    InverseTransformVector = function(_vector)
    {
        _vector.Sub(position);
        var local_x = (
            _vector.x * dcos(angle) -
            _vector.y * dsin(angle)
        ) / lossy_scale.x;
        var local_y = (
            _vector.x * dsin(angle) +
            _vector.y * dcos(angle)
        ) / lossy_scale.y;
        
        return new UWVector2(local_x, local_y);
    }
    
    /// Returns the topmost transform in the hierarchy.
    /// @returns {UWTransform} root transform
    
    GetRoot = function()
    {
        return parent == noone ? self : parent.GetRoot();
    }
    
    /// Unparents all children.
    
    DetachChildren = function()
    {
        foreachChild(function(_child){_child.SetParent(noone);});
        childs = [];
    }
    
    /// Is this transform a child of parent?
    ///
    /// @param {UWTransform} _transform
    /// @returns {bool} is child of passed transform
    
    IsChildOf = function(_transform)
    {
        if(parent != noone)
        {
            if(parent == _transform)
            {
                return true;
            }
            else
            {
                return parent.IsChildOf(_transform);   
            }
        }
        return false;
    }
    
    /// Returns a transform child by index.
    ///
    /// @param {number} _index Integer - Index of the child transform to return. Must be smaller than UWTransform.childCount.
    /// @returns {UWTransform} child transform
    
    GetChild = function(_index)
    {
        if(_index < childCount())
        {
            return childs[_index];
        }
        return noone;
    }
    
    // private section
    
    foreachChild = function(_func)
    {
        for(var i = 0; i < childCount(); i++)
        {
            _func(childs[i]);
        }
    }
	
	/// late init
	
	// pass instance of controlled obj in constructor
	
    if(argument[1] != undefined)
    {
        instance = argument[1];
		local_position = new UWVector2(instance.x, instance.y);
		local_angle = instance.image_angle;
		local_scale = new UWVector2(instance.image_xscale, instance.image_yscale);
		position = new UWVector2(local_position.x, local_position.y);
		angle = local_angle;
		lossy_scale = new UWVector2(local_scale.x, local_scale.y);
    }
	
	// pass parent transform in constructor
	
    if(argument[0] != undefined)
    {
        SetParent(argument[0], false);
    }
}
