extends Node

func activate():
	var myTextBox = get_node("..")
	var myTextContainer = myTextBox.get_node("..")
	var myNpc = myTextContainer.get_node("..")
	myNpc.textBox = myTextBox