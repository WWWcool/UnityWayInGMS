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

// struct-context -> call context
var test = {name : "Test"};
object.delegate.Add(function(){show_debug_message(name);}, test);
object.delegate.Run(); // Self Test

// clear and struct-context -> call context
object.delegate.Clear();
object.delegate.Add(function(){show_debug_message(name);}, object);
object.delegate.Run(); // Object

/* Correct console result
Self
Self
Test
Object
*/

show_debug_message("--");

object.delegate.Clear();
object.delegate.Add(test_method, test);
object.delegate.Add(test_method, test);
object.delegate.Add(test_method, id);
object.delegate.Remove(test_method, test); // delete last
object.delegate.Remove(test_method, id);

object.delegate.Run(); // Test
