

var object = {key: "hello"};
var delegate = new UWDelegate();

delegate.Add(function(context)
{
	show_message(context.key);
})

delegate.Add(function(context)
{
	show_message(context.key);
})

delegate.Add(function()
{
	show_message("the end");
})

delegate.Run(object);
