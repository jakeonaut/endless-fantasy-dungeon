extends AudioStreamPlayer

func _ready():
    pass

func activateScript():
    if global.memory.has("numCoins") and global.memory["numCoins"] >= 20:
        var myTextBox = get_node("..")
        # NodePath path is relative from self, 
        # which is to say from the NPC/NPC TextBox/TextBox/AbortSound
        myTextBox.nextTextboxPath = NodePath(@"../../GotCoin TextBox/TextBox")