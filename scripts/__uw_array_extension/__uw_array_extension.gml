// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

/// @desc With this function you can copy all or part of an array into another array at any position.
/// @param {array<T>} dest
/// @param {number} dest_index
/// @param {array<T>} src
/// @param {number} src_index
/// @param {number} length

function array_copy2(dest, dest_index, src, src_index, length)
{
    var dest_length = array_length(dest);
    var src_length = array_length(src);
    array_resize(dest, max(dest_length, dest_index + length));
    for(var i = 0; i < length; i++)
    {
        dest[@ i + dest_index] = src[i + src_index];
    }
}

/// @desc With this function you can create full copy of passed array.
/// @param {array<T>} array
/// @return {array<T>}

function array_clone(array)
{
    var length = array_length(array);
    if(length)
    {
        var clone = array_create(length);
        array_copy2(clone, 0, array, 0, length);
        return clone;
    }
    return [];
}
