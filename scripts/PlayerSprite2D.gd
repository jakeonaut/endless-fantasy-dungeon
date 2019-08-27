extends Sprite

onready var paletteTexture = get_node("eveningPeach").get_texture()

func _ready():
    self.material.set_shader_param("palette_tex", paletteTexture)
