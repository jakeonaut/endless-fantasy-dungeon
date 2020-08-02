extends MeshInstance

var flash_state = 0
var flash_counter = 0
var flash_count_limit = 3

# Called when the node enters the scene tree for the first time.
func _ready():
    set_process(true)

func _process(delta):
    if flash_state != 0:
        flash_counter += (delta*22)
        if flash_counter >= flash_count_limit:
            flash_counter = 0
            flash_state += 1
            self.get_mesh().set_size(Vector3(2, 2, 2))
            if flash_state >= 3:
                flash_state = 0
                self.visible = false

func flash():
    flash_counter = 0
    flash_state = 1
    self.visible = true
    self.get_mesh().set_size(Vector3(1, 1, 1))