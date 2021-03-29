
/// @param {array<T>} dest
/// @param {number} dest_index
/// @param {array<T>} src
/// @param {number} src_index
/// @param {number} length

function array_copy2(dest, dest_index, src, src_index, length)
{
    var dest_length = array_length(dest);
    var src_length = array_length(src);
    if((dest_index >= 0) and (src_length >= 0) and (src_index <= src_length - 1) and (length >= 1))
    {
        array_resize(dest, max(dest_length, dest_index + length));
        if(dest == src)
        {
            if(dest_index == src_index) 
                exit;
            
            if(dest_index > src_index)
            {
                while (length--) 
                    dest[@ length + dest_index] = src[length + src_index];
                
                exit;
            }
        }
        for(var i = 0; i < length; i++)
            dest[@ i + dest_index] = src[i + src_index];
    }
}

/// @param {array<T>} array
/// @returns {array<T>}

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