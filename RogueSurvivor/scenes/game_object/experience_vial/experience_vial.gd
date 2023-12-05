extends Node2D

@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var sprite = $Sprite2D


func _ready():
	$Area2D.area_entered.connect(on_area_entered)

func tween_collect(percent:float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = global_position - start_position
	rotation_degrees = rad_to_deg(direction_from_start.angle()) + 90

func disable_collision():
	collision_shape_2d.disabled = true

func on_area_entered(other_area: Area2D):
	Callable(disable_collision).call_deferred()
	var tween = create_tween()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5).\
	set_ease(tween.EASE_IN).\
	set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .47).set_delay(0.03)
	tween.chain()
	tween.tween_callback(collect)
	
	
func collect():
	GameEvents.emit_experience_vial_collected(1)
	queue_free()


