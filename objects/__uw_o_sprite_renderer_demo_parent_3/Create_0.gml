/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var parent_transform = new UWTransform(noone, id);
__uw_obj.AddComponent(parent_transform);

child = new UWObject();
var transform = new UWTransform(parent_transform);
child.AddComponent(transform);
var sprite_renderer = new UWSpriteRenderer(__uw_spr_sprite_renderer_demo_child);
child.AddComponent(sprite_renderer);

child.transform.SetLocalPositionAndAngleAndScale(
	new UWVector2(64, 64),
	0,
	new UWVector2(1, 1)
);

child2 = new UWObject();
transform = new UWTransform(transform);
child2.AddComponent(transform);
sprite_renderer = new UWSpriteRenderer(__uw_spr_sprite_renderer_demo_child);
child2.AddComponent(sprite_renderer);

child2.transform.SetLocalPositionAndAngleAndScale(
	new UWVector2(64, 64),
	0,
	new UWVector2(1, 1)
);

angle = 0;
