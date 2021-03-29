/// @description Insert description here
// You can write your code in this editor

// Inherit the parent event
event_inherited();

var object = {name : "Object", delegate: new UWDelegate()};

// object-context -> call context
name = "Self";
var test_method = function(){show_debug_message(name);};
object.delegate.Add(function(){show_debug_message(name);}, id);
object.delegate.Run(); // Self

//
var test = {name : "Test"};
object.delegate.Add(function(){show_debug_message(name);}, test);
object.delegate.Run(); // Self Test

with(test)
{
	test_method();	
}

//object.delegate.Remove(test_method, id);
//object.delegate.Run(); // Test

// + context
object.delegate.Clear();
object.delegate.Add(function(){show_debug_message(name);}, object);
object.delegate.Run(); // Object
