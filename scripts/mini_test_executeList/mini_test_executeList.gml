
function message_build(_prefix, _text)
{
	text += string(_prefix) + string(_text) + "\n";
}


var object = {text: ""};
var exec = new UWExecuteList().Bind(object);
exec.Add(message_build, " hello");
exec.Add(message_build, " how are you");
exec.Add(function()
{
	show_message(text);
});

exec.Run("ПУТИН ГОВОРИТ: ");
show_message(object.text);