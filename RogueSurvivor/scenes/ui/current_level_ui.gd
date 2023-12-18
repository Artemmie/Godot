extends CanvasLayer

@export var experience_manager: Node
@onready var label = $MarginContainer/Label

func _ready():
	label.text = "1"
	experience_manager.level_up.connect(on_level_up)
	
func on_level_up(current_level: int):
	label.text = str(current_level)
