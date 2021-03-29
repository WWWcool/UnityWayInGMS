

var object = {};
with (object)
{
	NameLocal = "Object";
	node = 
	{
		delegate: new UWDelegate()
	}
}

// non-context -> call context
NameLocal = "Kirill";
object.node.delegate.Add(function()
{
	show_message(NameLocal);
});

object.node.delegate.Run(); // Kirill 0

//
var space2 = {};
with (space2)
{
	NameLocal = "Superman";
	object.node.delegate.Run(); // Kirill 1
	with self object.node.delegate.Run(); // Superman 2
	var current = object.node;
	current.delegate.Run(); // Kirill 3
	var current = object.node.delegate;
	current.Run(); // Kirill 4
	
	with {}
	{
		NameLocal = "what is fuck"; // Superman 5
		current.Run();
	}
}

// + context
object.node.delegate.Clear();
object.node.delegate.Add(function()
{
	show_message(NameLocal);
}, object);

object.node.delegate.Run(); // Object