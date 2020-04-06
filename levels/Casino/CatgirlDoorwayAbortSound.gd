extends "res://scripts/AbortSound.gd"

# @override
func activateScript():
    if global.memory.has("numCoins") and global.memory["numCoins"] >= 20:
        var myTextBox = get_node("..")
        # NodePath path is relative from self, 
        # which is to say from the NPC/NPC TextBox/TextBox/AbortSound
        myTextBox.nextTextBoxPath = NodePath(@"../../GotCoin TextBox/TextBox")