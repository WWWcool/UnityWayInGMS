/// @Initialization

__uw_obj = new UWObject();
__uw_obj.LinkToInstance(id);

__uw_obj.AddGroup(
    UW_COMPONENT_GROUP_CREATE,
    function(_cmp)
    {
        return variable_struct_exists(_cmp, "create");
    },
    function(_cmp)
    {
        if(argument_count > 1)
            _cmp.create(argument[1]);
        else
            _cmp.create();
    }
)

__uw_obj.AddGroup(
    UW_COMPONENT_GROUP_STEP,
    function(_cmp)
    {
        return variable_struct_exists(_cmp, "step");
    },
    function(_cmp)
    {
        if(argument_count > 1)
            _cmp.step(argument[1]);
        else
            _cmp.step();
    }
)

__uw_obj.AddGroup(
    UW_COMPONENT_GROUP_DRAW,
    function(_cmp)
    {
        return variable_struct_exists(_cmp, "draw");
    },
    function(_cmp)
    {
        if(argument_count > 1)
            _cmp.draw(argument[1]);
        else
            _cmp.draw();
    }
)