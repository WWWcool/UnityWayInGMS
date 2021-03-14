// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_PREFAB_PREFIX "[UWPrefab]"
#macro UW_PREFAB_VERBOSE true

#macro UW_PREFAB_SEQTYPE_GRAPHIC    1
#macro UW_PREFAB_SEQTYPE_AUDIO      2
#macro UW_PREFAB_SEQTYPE_INSTANCE   14
#macro UW_PREFAB_SEQTYPE_SEQUENCE   7
#macro UW_PREFAB_SEQTYPE_MOMENT     16
#macro UW_PREFAB_SEQTYPE_GROUP      11
#macro UW_PREFAB_SEQTYPE_COLOUR     4
#macro UW_PREFAB_SEQTYPE_REAL       3
#macro UW_PREFAB_SEQTYPE_MESSAGE    15

#macro UW_PREFAB_DEFAULT_TRACK_POSITION "position"
#macro UW_PREFAB_DEFAULT_TRACK_SCALE    "scale"
#macro UW_PREFAB_DEFAULT_TRACK_ROTATION "rotation"
#macro UW_PREFAB_DEFAULT_TRACK_ORIGIN   "origin"

/// Parse sequences taged with "__uw_prefab" and make global object factory for each of it

function __uw_prefab_create_factories()
{
    gml_pragma("global", "__uw_prefab_create_factories()");
    
    #region local functions
    
    var extract_actions_from_seq = function(_data, _indent, _context)
    {
		_context.debug.PrintlnWithIndentIfDefined(UW_PREFAB_VERBOSE, "Seq: " + _data.name, _indent);
		
		if(is_array(_data.tracks))
		{
		    var track = _data.tracks[0];
		    var _index = asset_get_index(track.name);
            if(_index != -1 && asset_get_type(track.name) == asset_script)
            {
                array_push(_context.actions, new UWPrefabAction(
                    UWPrefabActionType.exec_script,
                    _index,
                    _context.current_level
                ));
                _context.debug.PrintlnWithIndentIfDefined(
                    UW_PREFAB_VERBOSE,
                    "Add exec script action: " + track.name,
                    _indent
                );
                
                var new_level = track.name == "__uw_prefab_create_transform";
                if(new_level)
                {
                    _context.current_level++;
                    _context.debug.PrintlnWithIndentIfDefined(
                        UW_PREFAB_VERBOSE,
                        "Level: " + string(_context.current_level),
                        _indent
                    );
                }
                return !new_level;
            } 
		}
		
		_data.extract_actions_from_tracks = method(_data, _context.extract_actions_from_tracks);
		_data.extract_actions_from_tracks(_indent + 1, _context);
		return false;
    }
    
    var extract_actions_from_tracks = function(_indent, _context)
    {
    	var skip_default_tracks = _context.extract_actions_from_frames(self, _indent, _context);
    
        // only for track struct
        var is_track = variable_struct_exists(self, "type");
        if(is_track)
        {
            // skip extract tracks for this types of track
            var skip_track = type == UW_PREFAB_SEQTYPE_GRAPHIC;
        			
    		if(skip_track)
    		    return;
        }
    	
    	if(!variable_struct_exists(self, "tracks"))
    		return;
    			
    	if(is_array(tracks))
    	{
    		for(var i = 0; i < array_length(tracks); i++)
    		{
    			var track = tracks[i];
    			var default_track = track.name == UW_PREFAB_DEFAULT_TRACK_POSITION
        			|| track.name == UW_PREFAB_DEFAULT_TRACK_SCALE
        			|| track.name == UW_PREFAB_DEFAULT_TRACK_ROTATION
        			|| track.name == UW_PREFAB_DEFAULT_TRACK_ORIGIN;
    			
    			if(default_track)
    			{
    			    if(!skip_default_tracks)
    			    {
        			    _context.debug.PrintlnWithIndentIfDefined(
        					UW_PREFAB_VERBOSE,
        					"Track: " + track.name + " type: " + _context.map_type(track.type),
        					_indent
        				);
        			    _context.extract_actions_from_frames(track, _indent, _context);
    			    }
    			}
    			else
    			{
        			_context.debug.PrintlnWithIndentIfDefined(
    					UW_PREFAB_VERBOSE,
    					"Track: " + track.name + " type: " + _context.map_type(track.type),
    					_indent
    				);
        			track.extract_actions_from_tracks = method(track, _context.extract_actions_from_tracks);
        			track.extract_actions_from_tracks(_indent + 1, _context);   
    			}
    		}
    	}
    	if(
    	    is_track && 
    	    (
    	        type == UW_PREFAB_SEQTYPE_INSTANCE || !skip_default_tracks
            )
        )
        {
            _context.current_level--;
            _context.debug.PrintlnWithIndentIfDefined(
                UW_PREFAB_VERBOSE,
                "Level: " + string(_context.current_level),
                _indent
            );
        }
    	
    }
    
    var extract_actions_from_frames = function(_struct, _indent, _context)
    {
        var skip_default_tracks = false;
		if(variable_struct_exists(_struct, "keyframes") && is_array(_struct.keyframes))
    	{
    	    if(array_length(_struct.keyframes) > 0)
    	    {
        	    var frame = _struct.keyframes[0];
    	        if(variable_struct_exists(frame, "channels") && is_array(frame.channels))
    	        {
            	    switch(_struct.type)
    				{
    				    case UW_PREFAB_SEQTYPE_REAL:
    				        var value = noone;
    				        var type = noone;
    				        var msg = "";
    				        switch(_struct.name)
    				        {
    				            case UW_PREFAB_DEFAULT_TRACK_POSITION:
    				                type = UWPrefabActionType.set_position_value;
    				                value = new UWVector2(
    				                    frame.channels[1].value,
    				                    frame.channels[0].value,
				                    );
				                    msg = value.ToString();
    				            break;
    				            case UW_PREFAB_DEFAULT_TRACK_SCALE:
    				                type = UWPrefabActionType.set_scale_value;
    				                value = new UWVector2(
    				                    frame.channels[1].value,
    				                    frame.channels[0].value,
				                    );
				                    
				                    msg = value.ToString();
    				            break;
    				            case UW_PREFAB_DEFAULT_TRACK_ROTATION:
    				                type = UWPrefabActionType.set_rotation_value;
    				                value = frame.channels[0].value;
				                    msg = string(value);
    				            break;
    				            case UW_PREFAB_DEFAULT_TRACK_ORIGIN:
    				                type = UWPrefabActionType.set_origin_value;
    				                value = new UWVector2(
    				                    frame.channels[1].value,
    				                    frame.channels[0].value,
				                    );
				                    msg = value.ToString();
    				            break;
    				        }
    				        array_push(_context.actions, new UWPrefabAction(type, value, _context.current_level));
                            _context.debug.PrintlnWithIndentIfDefined(
                                UW_PREFAB_VERBOSE,
                                "Add set value action... value: " + msg,
                                _indent
                            );
    				    break;
    				    case UW_PREFAB_SEQTYPE_INSTANCE:
    				        _context.current_level++;
    				        _context.debug.PrintlnWithIndentIfDefined(
                                UW_PREFAB_VERBOSE,
                                "Level: " + string(_context.current_level),
                                _indent
                            );
    				        array_push(_context.actions, new UWPrefabAction(
                                UWPrefabActionType.create_object,
                                frame.channels[0].objectIndex,
                                _context.current_level
                            ));
                            _context.debug.PrintlnWithIndentIfDefined(
                                UW_PREFAB_VERBOSE,
                                "Add create object action",
                                _indent
                            );
    				    break;
    				    case UW_PREFAB_SEQTYPE_GRAPHIC:
    				        array_push(_context.actions, new UWPrefabAction(
                                UWPrefabActionType.set_sprite,
                                frame.channels[0].spriteIndex,
                                _context.current_level
                            ));
                            _context.debug.PrintlnWithIndentIfDefined(
                                UW_PREFAB_VERBOSE,
                                "Add set sprite action",
                                _indent
                            );
    				    break;
    				    case UW_PREFAB_SEQTYPE_SEQUENCE:
    				        skip_default_tracks = 
								_context.extract_actions_from_seq(frame.channels[0].sequence, _indent, _context);
    				    break;
    				}
            	}
    	    }
    	}
		
		return skip_default_tracks;
    }
    
    #endregion
    
    var context =
    {
        debug : new UWUtilsDebug(UW_PREFAB_PREFIX),
        map_type : function(_type)
        {
            switch(_type){
                case UW_PREFAB_SEQTYPE_GRAPHIC:     return "seqtracktype_graphic";
                case UW_PREFAB_SEQTYPE_AUDIO:       return "seqtracktype_audio";
                case UW_PREFAB_SEQTYPE_INSTANCE:    return "seqtracktype_instance";
                case UW_PREFAB_SEQTYPE_SEQUENCE:    return "seqtracktype_sequence";
                case UW_PREFAB_SEQTYPE_MOMENT:      return "seqtracktype_moment";
                case UW_PREFAB_SEQTYPE_GROUP:       return "seqtracktype_group";
                case UW_PREFAB_SEQTYPE_COLOUR:      return "seqtracktype_colour";
                case UW_PREFAB_SEQTYPE_REAL:        return "seqtracktype_real";
                case UW_PREFAB_SEQTYPE_MESSAGE:     return "seqtracktype_message";
            }
            return "unknown_seqtracktype";
        },
        current_level : 0,
        actions : [],
        extract_actions_from_seq : extract_actions_from_seq,
        extract_actions_from_tracks : extract_actions_from_tracks,
        extract_actions_from_frames : extract_actions_from_frames
    }

    context.debug.double_indent = true;
    
    var prefab_sequences = tag_get_asset_ids("__uw_prefab", asset_sequence);
    context.debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "Found some prefab seq: " + string(prefab_sequences));
    
    if(is_array(prefab_sequences))
    {
    	var factories = {};
    	for(var i = 0; i < array_length(prefab_sequences); i++)
    	{
    		var seq = prefab_sequences[i];
    		if(sequence_exists(seq))
    		{
                var data = sequence_get(seq);
                context.actions = array_create(0);
        		context.extract_actions_from_seq(data, 0, context);
        		if(array_length(context.actions) > 0)
        		{
        		    context.debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "Create factory for seq: " + data.name);
        		    factories[$ data.name] = new UWPrefabFactory(data.name, context.actions);
        		}
        	}
    	}
    	global.__uw_prefab_factories = factories;
    }
}

/// Factory that can create or extend object from sequence blueprint.
/// @param {string} _id prefab sequence name
/// @param {array} _actions 
/// @returns {UWPrefabFactory} created factory

function UWPrefabFactory(_id, _actions) constructor
{
    id = _id
    actions = _actions;
    instance = noone;
    
    InstanceCreateLayer = function(_x, _y, _layer_id_or_name)
    {
        var debug = new UWUtilsDebug(UW_PREFAB_PREFIX);
        debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "InstanceCreateLayer for prefab: " + id);
        debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "actions count: " + string(array_length(actions)));
        for(var i = 0; i < array_length(actions); i++)
		{
		    var action = actions[i];
		    debug.PrintlnWithIndentIfDefined(UW_PREFAB_VERBOSE, "action type: " + string(action.type), action.level);
		}
        return noone;
    }
}

enum UWPrefabActionType 
{
    create_object,
    set_sprite,
    set_position_value,
    set_scale_value,
    set_rotation_value,
    set_origin_value,
    exec_script
}

/// Action that can create or change object or component struct.
/// @param {UWPrefabActionType} _type action context
/// @param _data data specific for action type
/// @param _level level on witch action should exec
/// @returns {UWPrefabAction} created action

function UWPrefabAction(_type, _data, _level) constructor
{
    type = _type;
    data = _data;
    level = _level;
}

