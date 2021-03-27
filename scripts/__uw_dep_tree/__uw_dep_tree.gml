// Unity way library. For more information see the documentation here:
// https://github.com/WWWcool/UnityWayInGMS/wiki

#macro UW_DEPENDENCY_PREFIX "[UWDependencyTree]"
#macro UW_DEPENDENCY_VERBOSE true

#macro UW_VECTOR_DEFINED false
#macro UW_TRANSFORM_DEFINED false

#macro UW_VECTOR_NAME "UWVector2"
#macro UW_TRANSFORM_NAME "UWTransform"
#macro UW_LOOP_NAME "UWLoop"

#macro UW_VECTOR_VERSION -1
#macro UW_TRANSFORM_VERSION -1

#macro UW_VECTOR_MIN_VERSION 1
#macro UW_TRANSFORM_MIN_VERSION 1

/// Dependency represents uw components connections to other components or libs.
/// @param {string} _name
/// @param {bool} _defined
/// @param {number} _version
/// @param {number} _min_version
/// @param {array(UWDependency)} _deps
/// @returns {UWDependency} created dependency

function UWDependency(_name, _defined, _version, _min_version, _deps) constructor
{
	name = _name;
	defined = _defined;
	version = _version;
	min_version = _min_version;
	deps = _deps;
	
	/// Check self defined and if ok check self deps defined
    ///
    /// @param {out array(UWDependencyValidateError)} _errors
	/// @param {number} _indent
    /// @returns {bool} has errors
    
    CheckDependencies = function(_errors, _indent)
    {
        var indent = _indent;
		var has_errors = false;
		if(!defined)
		{
			array_push(_errors, new UWDependencyValidateError(
				name,
				"Not defined in project",
				indent
			));
			has_errors = true;
		}
		else
		{
			if(version < min_version)
			{
				array_push(_errors, new UWDependencyValidateError(
					name,
						"Version mismatch -- min version: " +
						string(min_version) +
						", current version: " +
						string(version),
					indent
				));
				has_errors = true;
			}
			else
			{
				var failed_deps = array_create(0);
				for(var i = 0; i < array_length(deps); i++)
				{
					if(deps[i].CheckDependencies(failed_deps, indent + 1))
					{
						has_errors = true;	
					}
				}
				if(has_errors)
				{
					array_push(_errors, new UWDependencyValidateError(
						name,
						"Failed to validate deps",
						indent
					));
					array_copy(_errors, array_length(_errors), failed_deps, 0, array_length(failed_deps));
				}
				failed_deps = [];
			}
		}
		return has_errors;
    }
}

/// Represents error of dependency validation.
/// @param {string} _name
/// @param {string} _reason
/// @param {number} _indent
/// @returns {UWDependencyValidateError} created error

function UWDependencyValidateError(_name, _reason, _indent) constructor
{
	name = _name;
	reason = _reason;
	indent = _indent;
	
	static debug = new UWUtilsDebug(UW_DEPENDENCY_PREFIX);
	
	/// @returns {string} formatted error
    
    FormatError = function()
	{
		return debug.GetIndentString(indent) + "Dependency * " + name + " * failed with reason: " + reason;
	}
}

/// Use macro redefinition to validate hardcoded dependency tree

function __uw_validate_dep_tree()
{
    gml_pragma("global", "__uw_validate_dep_tree()");
	
    #region local functions
	var check_deps = function(_dep_array)
	{
		var failed_deps = array_create(0);
		for(var i = 0; i < array_length(_dep_array); i++)
		{
			_dep_array[i].CheckDependencies(failed_deps, 1);
			
		}
		return failed_deps;
	}
	
	var log_failed_deps = function(_cmp_name, _deps, _check_func)
	{
		var debug = new UWUtilsDebug(UW_DEPENDENCY_PREFIX);
		var failed_deps = _check_func(_deps)
		if(array_length(failed_deps) != 0)
		{
			debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, "Component * " + _cmp_name + " * has not all dependencies defined:");
			for(var i = 0; i < array_length(failed_deps); i++)
			{
				debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, failed_deps[i].FormatError());
			}
			debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, "****************** " + _cmp_name + " *\n");
			return false;
		}
		return true;
	}
	#endregion
	
	var vector_deps = []; //[new UWDependency("Test", false, 1, 1, [])];
	var transform_deps = [new UWDependency(UW_VECTOR_NAME, UW_VECTOR_DEFINED, UW_VECTOR_VERSION, UW_VECTOR_MIN_VERSION, vector_deps)];
	
	var debug = new UWUtilsDebug(UW_DEPENDENCY_PREFIX);
	debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, "Validate dependency tree:");
	
	var validate_res = true;
	
	if(UW_TRANSFORM_DEFINED) if(!log_failed_deps(UW_VECTOR_NAME, vector_deps, check_deps)) validate_res = false;
	if(UW_TRANSFORM_DEFINED) if(!log_failed_deps(UW_TRANSFORM_NAME, transform_deps, check_deps)) validate_res = false;
	
	if(validate_res)
	{
		debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, "Validation succeeded!");
	}
	else
	{
		debug.PrintlnIfDefined(UW_DEPENDENCY_VERBOSE, "Validation failed! See __uw_dep_tree.gml for more information");
	}
}
