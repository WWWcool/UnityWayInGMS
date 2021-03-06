// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

//#macro UW_VECTOR_DEFINED true
//#macro UW_VECTOR_VERSION 1

/// @desc Representation of 2D vectors and points.
/// TODO: need unit test for this
///
/// @param {number} _x X component of the vector.
/// @param {number} _y Y component of the vector.
/// @return {UWVector2} created vector2

function UWVector2(_x, _y) constructor
{
    static zero_vector = function(){return new UWVector2(0.0, 0.0);};
    static one_vector = function(){return new UWVector2(1.0, 1.0)};
    static up_vector = function(){return new UWVector2(0.0, 1.0)};
    static down_vector = function(){return new UWVector2(0.0, -1.0)};
    static left_vector = function(){return new UWVector2(-1.0, 0.0)};
    static right_vector = function(){return new UWVector2(1.0, 0.0)};

    x = _x;
    y = _y;
    
    /// @desc Linearly interpolates between vectors a and b by t.
    ///
    /// @param {UWVector2} _a
    /// @param {UWVector2} _b
    /// @param {number} _t
    /// @return {UWVector2} vector2
    
    static Lerp = function(_a, _b, _t)
    {
        _t = clamp(_t, 0, 1);
        return new UWVector2(_a.x + (_b.x - _a.x) * _t, _a.y + (_b.y - _a.y) * _t);
    }
    
    /// @desc Linearly interpolates between vectors a and b by t.
    ///
    /// @param {UWVector2} _a
    /// @param {UWVector2} _b
    /// @param {number} _t
    /// @return {UWVector2} vector2
    
    static LerpUnclamped = function(_a, _b, _t)
    {
        return new UWVector2(_a.x + (_b.x - _a.x) * _t, _a.y + (_b.y - _a.y) * _t);
    }
    
    /// @desc Moves a point current towards target.
    ///
    /// @param {UWVector2} _current
    /// @param {UWVector2} _target
    /// @param {number} _max_distance_delta
    /// @return {UWVector2} vector2
    
    static MoveTowards = function(
        _current,
        _target,
        _max_distance_delta
    )
    {
        var num1 = _target.x - _current.x;
        var num2 = _target.y - _current.y;
        var num3 = num1 * num1 + num2 * num2;
        if(
            num3 == 0.0
            || _max_distance_delta >= 0.0
            && num3 <=  _max_distance_delta * _max_distance_delta
        )
            return _target;
        var num4 = sqrt(num3);
        return new UWVector2(
            _current.x + num1 / num4 * _max_distance_delta,
            _current.y + num2 / num4 * _max_distance_delta
        );
    }
    
    /// @desc Multiplies two vectors component-wise.
    ///
    /// @param {UWVector2} _a
    /// @param {UWVector2} _b
    /// @return {UWVector2} vector2
    
    static Scale = function(_a, _b)
    {
        return new UWVector2(_a.x * _b.x, _a.y * _b.y);
    }
    
    /// @desc return the unsigned angle in degrees between from and to.
    ///
    /// @param {UWVector2} _from
    /// @param {UWVector2} _to
    /// @return {number} angle
    
    static Angle = function(_from, _to)
    {
        return point_direction(_from.x, _from.y, _to.x, _to.y);
    }
    
    /// @desc return the signed angle in degrees between from and to.
    ///
    /// @param {UWVector2} _from
    /// @param {UWVector2} _to
    /// @return {number} angle
    
    static SignedAngle = function(_from, _to)
    {
        return UWVector2.Angle(_from, _to) * sign((_from.x * _to.y - _from.y * _to.x));
    }
    
    /// @desc return the distance between a and b.
    ///
    /// @param {UWVector2} _a
    /// @param {UWVector2} _b
    /// @return {number} distance
    
    static Distance = function(_a, _b)
    {
        return point_distance(_a.x, _a.y, _b.x, _b.y);
    }
    
    /// @desc return a copy of vector with its magnitude clamped to maxLength.
    ///
    /// @param {UWVector2} _vector
    /// @param {number} _max_length
    /// @return {UWVector2} magnitude
    
    static ClampMagnitude = function(_vector, _max_length)
    {
        var sqr_magnitude = vector.SqrMagnitude();
        if(sqr_magnitude <= _max_length * _max_length)
            return _vector;
        var num1 = sqrt(sqr_magnitude);
        var num2 = vector.x / num1;
        var num3 = vector.y / num1;
        return new UWVector2(num2 * _max_length, num3 * _max_length);
    }
    
    /// @desc return a vector that is made from the smallest components of two vectors.
    ///
    /// @param {UWVector2} _lhs
    /// @param {UWVector2} _rhs
    /// @return {UWVector2} vector2
    
    static Min = function(_lhs, _rhs)
    {
        return new UWVector2(min(_lhs.x, _rhs.x), min(_lhs.y, _rhs.y));
    }
    
    /// @desc return a vector that is made from the largest components of two vectors.
    ///
    /// @param {UWVector2} _lhs
    /// @param {UWVector2} _rhs
    /// @return {UWVector2} vector2
    
    static Max = function(_lhs, _rhs)
    {
        return new UWVector2(max(_lhs.x, _rhs.x), max(_lhs.y, _rhs.y));
    }
    
    /// @desc Set x and y components of an existing Vector2.
    ///
    /// @param {number} _new_x
    /// @param {number} _new_y
    
    static Set = function(_new_x, _new_y)
    {
        x = _new_x;
        y = _new_y;
    }
    
    /// @desc Multiplies every component of this vector by the same component of scale.
    ///
    /// @param {UWVector2} _scale
    
    static Scale = function(_scale)
    {
        x *= _scale.x;
        y *= _scale.y;
    }
    
    /// @desc return the length of this vector (Read Only).
    /// @return {number} magnitude
    
    static Magnitude = function(){ return sqrt(x * x + y * y);}
    
    /// @desc return the squared length of this vector (Read Only).
    /// @return {number} sqr magnitude
    
    static SqrMagnitude = function(){ return x * x + y * y;}
    
    /// @return {UWVector2} vector2
    
    static Add = function(_vector)
    {
        return new UWVector2(x + _vector.x, y + _vector.y);
    }
    
    /// @return {UWVector2} vector2
    
    static Sub = function(_vector)
    {
        return new UWVector2(x - _vector.x, y - _vector.y);
    }
    
    /// @return {UWVector2} vector2
    
    static Mult = function(_vector_or_number)
    {
        return new UWVector2(
            is_numeric(_vector_or_number) ? x * _vector_or_number : x * _vector_or_number.x,
            is_numeric(_vector_or_number) ? y * _vector_or_number : y * _vector_or_number.y);
    }
    
    /// @return {UWVector2} vector2
    
    static Div = function(_vector_or_number)
    {
        return new UWVector2(
            is_numeric(_vector_or_number) ? x / _vector_or_number : x / _vector_or_number.x,
            is_numeric(_vector_or_number) ? y / _vector_or_number : y / _vector_or_number.y);
    }
    
    /// @return {UWVector2} vector2
    
    static Inv = function()
    {
        return new UWVector2(-x, -y);
    }
    
    /// @return {bool} is equals
    
    static Equals = function(_vector)
    {
        var num1 = x - _vector.x;
        var num2 = y - _vector.y;
        return num1 * num1 + num2 * num2 < math_get_epsilon();
    }
    
    /// @return {string} formatted output
    
    static ToString = function()
    {
        return "(" + string(x) + ", " + string(y) + ")";
    }
}
