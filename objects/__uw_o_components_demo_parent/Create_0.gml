/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

__uw_obj.AddGroup(
    "MouseEnter",
    function(_cmp)
    {
        return variable_struct_exists(_cmp, "onMouseEnter");
    },
    function(_cmp)
    {
        if(argument_count > 1)
            _cmp.onMouseEnter(argument[1]);
        else
            _cmp.onMouseEnter();
    }
)

__uw_obj.AddGroup(
    "MouseLeave",
    function(_cmp)
    {
        return variable_struct_exists(_cmp, "onMouseLeave");
    },
    function(_cmp)
    {
        if(argument_count > 1)
            _cmp.onMouseLeave(argument[1]);
        else
            _cmp.onMouseLeave();
    }
)
