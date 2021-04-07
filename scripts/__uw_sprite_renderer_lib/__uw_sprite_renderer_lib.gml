// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_SPRITE_RENDERER_TYPE_ID 10101
#macro UW_SPRITE_RENDERER_NAME "UWSpriteRenderer"
#macro UW_SPRITE_RENDERER_DEFINED true
#macro UW_SPRITE_RENDERER_VERSION 1

/// @desc Renders a Sprite for 2D graphics.
/// @param {sprite} [_sprite] sprite to render
/// @return {UWSpriteRenderer} created sprite_renderer

function UWSpriteRenderer(_sprite) : UWComponent(UW_SPRITE_RENDERER_TYPE_ID, UW_SPRITE_RENDERER_NAME) constructor
{
    sprite = argument[0] == undefined ? noone : _sprite;
    subimg = 0;
    subimg_count = argument[0] == undefined ? 1 : sprite_get_number(_sprite);
    size = argument[0] == undefined ? new UWVector2(0, 0) : new UWVector2(sprite_get_width(_sprite), sprite_get_height(_sprite));
    color = c_white;
    alpha = 1;
    flipX = false;
    flipY = false;
    
    /// @desc Method to fit into standart draw component group
    
    static draw = function()
    {
        DrawSprite();
    }
    
    /// @desc Get info string specific for this component
    /// @return {string} info
    
    static GetInfo = function()
    {
        return "sprite: " + string(sprite);
    }
    
    /// @desc Set new sprite for 2D renderer.
    /// @param {sprite} [_sprite] sprite to render
    
    static SetSprite = function(_sprite)
    {
        sprite = _sprite;
        subimg_count = sprite_get_number(_sprite);
        size = new UWVector2(sprite_get_width(_sprite), sprite_get_height(_sprite));
    }
    
    /// @desc Renders a Sprite for 2D graphics.
    
    static DrawSprite = function()
    {
        if(!sprite_exists(sprite))
            return;
        
        var transform = game_object.transform;
        if(flipX || flipY || alpha != 1 || transform.angle != 0 || !transform.lossy_scale.Equals(new UWVector2(1, 1)))
        {
            draw_sprite_ext(
                sprite,
                round(subimg),
                transform.position.x,
                transform.position.y,
                flipX ? -transform.lossy_scale.x : transform.lossy_scale.x,
                flipY ? -transform.lossy_scale.y : transform.lossy_scale.y,
                transform.angle,
                color,
                alpha
            );
        }
        else
        {
            draw_sprite(
                sprite,
                round(subimg),
                transform.position.x,
                transform.position.y
            );
        }
    }
    
    /// @desc Increment saved image index of sprite renderer.
    
    static IncrementImageIndex = function(_amount)
    {
        subimg = clamp(subimg + _amount, 0, subimg_count);
    }
}
