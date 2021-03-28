
/// Returns a string array that contains the substrings in this instance that are delimited by elements of a specified string.
/// @param {string} _data string instance
/// @param {string} _separator a string that delimit the substrings in this instance. 
/// @returns {array(string)} created data

function string_split(_data, _separator)
{
    var res = [];
    var start_index = 1;
    for(var i = 1; i < string_length(_data); i++)
    {
        var index = string_pos_ext(_separator, _data, start_index);
        if(index != 0)
        {
            var sub = string_copy(_data, start_index, index - start_index);
            array_push(res, sub);
            start_index = index + 1;
        }
        else if(start_index != 1)
        {
            var sub = string_copy(_data, start_index, string_length(_data) - start_index + 1);
            array_push(res, sub);
            break;
        }
    }
    
    return res;
}
