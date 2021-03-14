/// @description Insert description here
// You can write your code in this editor

if(variable_global_exists("__uw_prefab_factories"))
{
	var prefab = global.__uw_prefab_factories[$ "__uw_prefab_test"];
	var inst = prefab.InstanceCreateLayer(x, y, "Instances");
	if(instance_exists(inst))
	{
		show_debug_message("Instance create!!!!");
	}
}
