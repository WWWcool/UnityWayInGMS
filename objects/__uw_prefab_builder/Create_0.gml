/// @description Insert description here
// You can write your code in this editor

show_tracks_2 = function(_struct){
	if(!variable_struct_exists(_struct, "tracks"))
		return;
			
	var tracks = _struct.tracks;
	if(is_array(tracks))
	{
		for(var k = 0; k < array_length(tracks); k++)
		{
			var track = tracks[k];
			show_debug_message("Find track: " + track.name);
			show_debug_message("Track type: " + string(track.type));
		}
	}
}

var show_tracks_1 = function(_struct){
	if(!variable_struct_exists(_struct, "tracks"))
		return;
			
	var tracks = _struct.tracks;
	if(is_array(tracks))
	{
		for(var k = 0; k < array_length(tracks); k++)
		{
			var track = tracks[k];
			show_debug_message("Find track: " + track.name);
			show_debug_message("Track type: " + string(track.type));
			show_tracks_2(track);
		}
	}
}


if(is_array(prefab_list))
{
	for(var i = 0; i < array_length(prefab_list); i++)
	{
		var seq = prefab_list[i];
		if(sequence_exists(seq))
		{
			var data = sequence_get(seq);
			show_debug_message("Find seq: " + data.name);
			
			show_tracks_1(data);
		}
	}
}
