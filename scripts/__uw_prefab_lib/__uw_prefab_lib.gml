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
		    var len = array_length(_data.tracks);
		    var track = _data.tracks[len - 1];
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
                
                if(len > 1)
                {
                	for(var i = len - 2; i >= 0; i--)
                	{
                		var parts = string_split(_data.tracks[i].name, "_");
                		if(array_length(parts) > 2)
                		{
                			var value_data_type = _context.map_action_data_type(parts[0]);
                			var value_data = new UWPrefabSetValueData(value_data_type, parts[1]);
                			value_data.SetDataFrom(parts[2]);
                			array_push(_context.actions, new UWPrefabAction(
			                    UWPrefabActionType.set_value,
			                    value_data,
			                    _context.current_level
			                ));
			                _context.debug.PrintlnWithIndentIfDefined(
			                    UW_PREFAB_VERBOSE,
			                    "Add set value action: " + _data.tracks[i].name,
			                    _indent
			                );
                		}
                	}
                }
                
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
        
        map_action_data_type : function(_type)
        {
            switch(_type){
                case "bool": return UWPrefabActionValueType.bool;
                case "real": return UWPrefabActionValueType.real;
                case "string": return UWPrefabActionValueType.string;
                case "vector2": return UWPrefabActionValueType.vector2;
                case "asset_id": return UWPrefabActionValueType.asset_id;
            }
            return -1;
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
    uw_objects = array_create(0);
    
    
    InstanceCreateLayer = function(_x, _y, _layer_id_or_name)
    {
        var debug = new UWUtilsDebug(UW_PREFAB_PREFIX);
        debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "InstanceCreateLayer for prefab: " + id);
        debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "actions count: " + string(array_length(actions)));
        var current_level = 0;
        var root_level = 0;
        var inst = noone;
        var last_created_struct = noone;
        for(var i = 0; i < array_length(actions); i++)
		{
		    var action = actions[i];
		    
		    if(action.level < current_level)
		    {
		        var obj = array_pop(uw_objects);
		    }
		    
		  //  debug.PrintlnWithIndentIfDefined(UW_PREFAB_VERBOSE, "uw_objects count: " + string(array_length(uw_objects)), action.level);
		    
		    var current_obj = array_length(uw_objects) > 0 ? array_get(uw_objects, array_length(uw_objects) - 1) : noone;
		    
		    switch(action.type)
		    {
		        case UWPrefabActionType.create_object:
		            if(current_level == 0)
		            {
		                inst = instance_create_layer(_x, _y, _layer_id_or_name, action.data);
		                if(instance_exists(inst))
                        {
                            if(!__uw_check_instance(inst))
                                show_error("Fail to create instance that is not child of __uw_object", true);
                                
                            var transform = new UWTransform(noone, inst);
                            inst.__uw_obj.AddComponent(transform);
                            root_level = action.level;
                			array_push(uw_objects, inst.__uw_obj);
                        }
		            }
		            else
		            {
		                inst = instance_create_layer(0, 0, _layer_id_or_name, action.data);
		                if(instance_exists(inst))
                        {
                            if(!__uw_check_instance(inst))
                                show_error("Fail to create instance that is not child of __uw_object", true);
                                
                            var transform = new UWTransform(current_obj, inst);
                            inst.__uw_obj.AddComponent(transform);
                			array_push(uw_objects, inst.__uw_obj);
                        }
		            }
		            last_created_struct = inst;
		        break;
		        case UWPrefabActionType.set_sprite:
		            if(instance_exists(current_obj.transform.instance))
		            {
		                current_obj.transform.instance.sprite_index = action.data;
		            }
		            else
		            {
		                var sprite_renderer = current_obj.GetComponentByTypeID(UW_SPRITE_RENDERER_TYPE_ID);
		                if(is_struct(sprite_renderer))
		                {
		                    sprite_renderer.SetSprite(action.data);
		                }
		            }
		        break;
		        case UWPrefabActionType.set_position_value:
		            if(root_level == current_level)
		            {
		                current_obj.transform.SetLocalPositionAndAngleAndScale(
		                    current_obj.transform.local_position.Add(action.data),
		                    current_obj.transform.local_angle,
		                    current_obj.transform.local_scale
	                    );
		            }
		            else
		            {
		                current_obj.transform.SetLocalPositionAndAngleAndScale(
		                    action.data,
		                    current_obj.transform.local_angle,
		                    current_obj.transform.local_scale
	                    );
		            }
		        break;
		        case UWPrefabActionType.set_scale_value:
		            if(instance_exists(current_obj.transform.instance))
		            {
		                current_obj.transform.SetLocalPositionAndAngleAndScale(
		                    current_obj.transform.local_position,
		                    current_obj.transform.local_angle,
		                    action.data
	                    );
		            }
		        break;
		        case UWPrefabActionType.set_rotation_value:
		            if(instance_exists(current_obj.transform.instance))
		            {
		                current_obj.transform.SetLocalPositionAndAngleAndScale(
		                    current_obj.transform.local_position,
		                    action.data,
		                    current_obj.transform.local_scale
	                    );
		            }
		        break;
		        case UWPrefabActionType.set_origin_value:
		            debug.PrintlnIfDefined(UW_PREFAB_VERBOSE, "Fail to set origin, reason: not implemented");
		        break;
		        case UWPrefabActionType.exec_script:
		            var created_struct = action.data();
		            if(instanceof(created_struct) == UW_BASE_NAME)
		            {
		                var transform = new UWTransform(current_obj.transform);
                        created_struct.AddComponent(transform);
            			array_push(uw_objects, created_struct);
		            }
		            else
		            {
		                current_obj.AddComponent(created_struct);
		            }
		            last_created_struct = created_struct;
		        break;
		        case UWPrefabActionType.set_value:
		        	if(is_struct(last_created_struct) || instance_exists(last_created_struct))
		        	{
		        		action.data.ApplyValueTo(last_created_struct);
		        	}
		        break;
		    }
		    current_level = action.level;
		  //  debug.PrintlnWithIndentIfDefined(UW_PREFAB_VERBOSE, "action type: " + string(action.type), action.level);
		}
        return inst;
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
    exec_script,
    set_value
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

enum UWPrefabActionValueType 
{
    bool,
    real,
    string,
    vector2,
    asset_id
}

/// Data to set value of created instance.
/// @param {UWPrefabActionValueType} _type value type
/// @param {string} _name value name
/// @returns {UWPrefabSetValueData} created data

function UWPrefabSetValueData(_type, _name) constructor
{
    type = _type;
    name = _name;
    value = noone;
    
	/// @param {string} _data string to extract data from
	
    static SetDataFrom = function(_data)
    {
    	switch(type)
    	{
    		case UWPrefabActionValueType.bool:
    			switch(_data)
    			{
    				case "true":
    					value = true;
    				break;
    				case "false":
    					value = false;
    				break;
    			}
    		break;
    		case UWPrefabActionValueType.real:
    			value = real(_data);
    		break;
    		case UWPrefabActionValueType.string:
    			value = _data;
    		break;
    		case UWPrefabActionValueType.vector2:
    			_data = string_replace_all(_data, "(", "");
    			_data = string_replace_all(_data, ")", "");
    			var parts = string_split(_data, ",");
        		if(array_length(parts) > 1)
        		{
        			value = new UWVector2(real(parts[0]), real(parts[1]));
        		}
    		break;
    		case UWPrefabActionValueType.asset_id:
    			value = real(_data);
    		break;
    	}
    }
    
    /// @param {instance | struct} _instance_or_struct to apply this value to
    
    static ApplyValueTo = function(_instance_or_struct)
    {
    	if(value == noone)
    		return;
    	
    	if(is_struct(_instance_or_struct))
		{
			if(variable_struct_exists(_instance_or_struct, name))
			{
				variable_struct_set(_instance_or_struct, name, value);
			}
		}
		else
		{
			if(variable_instance_exists(_instance_or_struct, name))
			{
				variable_instance_set(_instance_or_struct, name, value);
			}
		}
    }
}
