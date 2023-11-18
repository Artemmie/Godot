extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_for_flip()


func check_for_flip():
	if Input.get_action_strength("move_right") && flip_h:
		flip_h = false
	if Input.get_action_strength("move_left") && !flip_h:
		flip_h = true
