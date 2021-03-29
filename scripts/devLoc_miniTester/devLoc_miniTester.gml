

var object = {};
with (object)
{
	NameLocal = "Object";
	node = 
	{
		delegate: new UWDelegate()
	}
}

//
object.node.delegate.Clear();
object.node.delegate.Add(function()
{
	show_message(NameLocal);
}, object);

object.node.delegate.Run(); // Object