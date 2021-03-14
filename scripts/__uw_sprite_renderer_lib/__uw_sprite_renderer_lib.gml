// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_SPRITE_RENDERER_TYPE_ID 10101
#macro UW_SPRITE_RENDERER_NAME "UWSpriteRenderer"
#macro UW_SPRITE_RENDERER_DEFINED true
#macro UW_SPRITE_RENDERER_VERSION 1

/// Renders a Sprite for 2D graphics.
/// @param {sprite} [_sprite] sprite to render
/// @returns {UWSpriteRenderer} created sprite_renderer

function UWSpriteRenderer(_sprite) : UWComponent(UW_SPRITE_RENDERER_TYPE_ID, UW_SPRITE_RENDERER_NAME) constructor
{
    sprite = _sprite;
    subimg = 0;
    subimg_count = sprite_get_number(_sprite);
    size = new UWVector2(sprite_get_width(_sprite), sprite_get_height(_sprite));
    color = c_white;
    alpha = 1;
    flipX = false;
    flipY = false;
    
    DrawSprite = function()
    {
        var transform = game_object.transform;
        if(flipX || flipY || alpha != 1 || transform.angle != 0)
        {
            draw_sprite_ext(
                sprite,
                round(subimg),
                transform.position.x,
                transform.position.y,
                transform.lossy_scale.x,
                transform.lossy_scale.y,
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
    
    IncrementImageIndex = function(_amount)
    {
        subimg = clamp(subimg + _amount, 0, subimg_count);
    }
}
