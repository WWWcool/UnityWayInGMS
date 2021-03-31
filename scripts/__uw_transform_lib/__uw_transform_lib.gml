// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_TRANSFORM_TYPE_ID 10001
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
    static childCount = function(){return array_length(childs)};
    instance = noone;
    
	/***
		*** SEE LATE INIT AT THE END OF THIS FILE ***
	***/
	
	/// Get info string specific for this component
    /// @returns {string} info
    
    static GetInfo = function()
    {
        return "position: " + position.ToString() + 
        " angle: " + string(angle) + 
        " scale: " + lossy_scale.ToString();
    }
	
	/// Set the instance of the transform.
    ///
    /// @param {object} _obj
    /// @param {bool} [_object_position_stays]
    
    static SetInstance = function(_obj)
    {
        if(!instance_exists(_obj))
            return;
        
        var _object_position_stays = argument_count > 1 ? argument[1] : true;
        if(_object_position_stays)
        {
            instance = _obj;
    		position = new UWVector2(instance.x, instance.y);
    		angle = instance.image_angle;
    		lossy_scale = new UWVector2(instance.image_xscale, instance.image_yscale);
    		if(is_struct(parent))
    		{
    		    local_position = parent.InverseTransformVector(position);
                local_angle = parent.InverseTransformDirection(angle);
                local_scale = parent.InverseTransformScale(lossy_scale);
    		}
    		else
    		{
    		    local_position = position;
                local_angle = angle;
                local_scale = lossy_scale;
    		}
    		SetPositionAndAngleAndScale(position, angle, lossy_scale);
        }
        else
        {
            instance = _obj;
            instance.y = position.y;
            instance.x = position.x;
            instance.image_xscale = lossy_scale.x;
            instance.image_yscale = lossy_scale.y;
            instance.image_angle = angle;
        }
    }
	
    /// Set the parent of the transform.
    ///
    /// @param {UWTransform} _transform
    /// @param {bool} [_world_position_stays]
    
    static SetParent = function(_transform)
    {
        var _world_position_stays = argument_count > 1 ? argument[1] : true;
        
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
        
        if(parent != noone)
        {
            if(_world_position_stays)
            {
                local_position = parent.InverseTransformVector(position);
                local_angle = parent.InverseTransformDirection(angle);
                local_scale = parent.InverseTransformScale(lossy_scale);
            }
            else
            {
                SetLocalPositionAndAngleAndScale(local_position, local_angle, local_scale);
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
    }
    
    /// Sets the world space position, angle and scale of the Transform component.
    ///
    /// @param {UWVector2} _position
    /// @param {number} _angle
    /// @param {UWVector2} _scale
    
    static SetPositionAndAngleAndScale = function(_position, _angle, _scale)
    {
        position = _position;
        angle = _angle;
        lossy_scale = _scale;
        
        if(parent != noone)
        {
            local_position = parent.InverseTransformVector(position);
            local_angle = parent.InverseTransformDirection(angle);
            local_scale = parent.InverseTransformScale(lossy_scale);
        }
        else
        {
            local_position = position;
            local_angle = angle;
            local_scale = lossy_scale;
        }
        
        if(instance_exists(instance))
        {
            instance.x = position.x;
            instance.y = position.y;
            instance.image_xscale = lossy_scale.x;
            instance.image_yscale = lossy_scale.y;
            instance.image_angle = angle;
        }
        
        ForeachChild(function(_child)
        {
            // _child.SetLocalPositionAndAngleAndScale
            // (
            //     _child.local_position,
            //     _child.local_angle,
            //     _child.local_scale
            // );
            _child.SetPositionAndAngleAndScale
            (
                TransformVector(_child.local_position),
                TransformDirection(_child.local_angle),
                TransformScale(_child.local_scale)
            );
        });
    }
    
    /// Sets the local space position, angle and scale of the Transform component.
    ///
    /// @param {UWVector2} _position
    /// @param {number} _angle
    /// @param {UWVector2} _scale
    
    static SetLocalPositionAndAngleAndScale = function(_position, _angle, _scale)
    {
        local_position = _position;
        local_angle = _angle;
        local_scale = _scale;
        
        if(parent != noone)
        {
            position = parent.TransformVector(local_position);
            angle = parent.TransformDirection(local_angle);
            lossy_scale = parent.TransformScale(local_scale);
        }
        else
        {
            position = _position;
            angle = _angle;
            lossy_scale = _scale;
        }
        
        if(instance_exists(instance))
        {
            instance.x = position.x;
            instance.y = position.y;
            instance.image_xscale = lossy_scale.x;
            instance.image_yscale = lossy_scale.y;
            instance.image_angle = angle;
        }
        
        ForeachChild(function(_child)
        {
            _child.SetLocalPositionAndAngleAndScale
            (
                _child.local_position,
                _child.local_angle,
                _child.local_scale
            );
        });
    }
    
    /// Moves the transform in the direction and distance of translation.
    ///
    /// @param {UWVector2} _translation
    /// @param {UWTransform} _relativeTo
    
    static Translate = function(_translation, _relativeTo)
    {
        throwNotImplemented("Translate");
    }
    
    /// Rotates the object around by the number of degrees defined by the given angle.
    ///
    /// @param {UWVector2} _angle
    /// @param {UWTransform} _relativeTo
    
    static Rotate = function(_angle, _relativeTo)
    {
        throwNotImplemented("Rotate");
    }
    
    /// Rotates the transform so the forward vector points at target's current position.
    ///
    /// @param {UWTransform} _target
    
    static LookAt = function(_target)
    {
        throwNotImplemented("LookAt");
    }
    
    /// Transforms direction from local space to world space.
    ///
    /// @param {number} _direction
    /// @returns {number} world space direction
    
    static TransformDirection = function(_direction)
    {
        return _direction + angle;
    }
    
    /// Transforms a direction from world space to local space.
    ///
    /// @param {number} _direction
    /// @returns {number} local space direction
    
    static InverseTransformDirection = function(_direction)
    {
        return _direction - angle;
    }
    
    /// Transforms scale from local space to world space.
    ///
    /// @param {UWVector2} _scale
    /// @returns {UWVector2} world space scale
    
    static TransformScale = function(_scale)
    {
        return _scale.Mult(lossy_scale);
    }
    
    /// Transforms scale from world space to local space.
    ///
    /// @param {UWVector2} _scale
    /// @returns {UWVector2} local space scale
    
    static InverseTransformScale = function(_scale)
    {
        return _scale.Div(lossy_scale);
    }
    
    /// Transforms vector from local space to world space.
    ///
    /// @param {UWVector2} _vector
    /// @returns {UWVector2} world space vector
    
    static TransformVector = function(_vector)
    {
        var world_x =  (
            lossy_scale.x * _vector.x * dcos(-angle) -
            lossy_scale.y * _vector.y * dsin(-angle)
        ) + position.x;
        var world_y =  (
            lossy_scale.x * _vector.x * dsin(-angle) +
            lossy_scale.y * _vector.y * dcos(-angle)
        ) + position.y;
        
        return new UWVector2(world_x, world_y);
    }
    
    /// Transforms vector from world space to local space.
    ///
    /// @param {UWVector2} _vector
    /// @returns {UWVector2} local space vector
    
    static InverseTransformVector = function(_vector)
    {
        var vector = _vector.Sub(position);
        var local_x = (
            vector.x * dcos(angle) -
            vector.y * dsin(angle)
        ) / lossy_scale.x;
        var local_y = (
            vector.x * dsin(angle) +
            vector.y * dcos(angle)
        ) / lossy_scale.y;
        
        return new UWVector2(local_x, local_y);
    }
    
    /// Returns the topmost transform in the hierarchy.
    /// @returns {UWTransform} root transform
    
    static GetRoot = function()
    {
        return parent == noone ? self : parent.GetRoot();
    }
    
    /// Unparents all children.
    
    static DetachChildren = function()
    {
        ForeachChild(function(_child){_child.SetParent(noone);});
        childs = [];
    }
    
    /// Is this transform a child of parent?
    ///
    /// @param {UWTransform} _transform
    /// @returns {bool} is child of passed transform
    
    static IsChildOf = function(_transform)
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
    
    static GetChild = function(_index)
    {
        if(_index < childCount())
        {
            return childs[_index];
        }
        return noone;
    }
    
    static ForeachChild = function(_func)
    {
        if(argument_count > 1)
        {
            for(var i = 0; i < childCount(); i++)
            {
                _func(childs[i], argument[1]);
            }
        }
        else
        {
            for(var i = 0; i < childCount(); i++)
            {
                _func(childs[i]);
            }
        }
    }
	
	/// late init
	
	// pass instance of controlled obj in constructor
	
    if(argument_count > 1)
    {
		SetInstance(argument[1])
    }
	
	// pass parent transform in constructor
	
    if(argument_count > 0)
    {
        SetParent(argument[0], false);
    }
}
