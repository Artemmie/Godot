extends Node

@export var max_speed: int = 40
@export var acceleration: float = 5

signal stop_walking_animation
signal start_walking_animation

var velocity = Vector2.ZERO
var sign = 1

const MAX_DISTANCE: float = 130
const MIN_DISTANCE: float = 100

var safe_area = true
func accelerate_to_player():
	var owner_node2d = owner as Node2D
	if owner_node2d == null:
		return
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	var ranged = owner_node2d.is_in_group("ranged")
	var direction = (player.global_position - owner_node2d.global_position).normalized()
	if ranged:
		var distance_to_player = (player.global_position - owner_node2d.global_position).length()
		print("distance:", distance_to_player)
		if (distance_to_player >= MIN_DISTANCE and distance_to_player <= MAX_DISTANCE):
			decelerate()
			#if sign(velocity.x) != sign(direction.x):
			velocity.x = sign(player.global_position.x - owner_node2d.global_position.x)
			stop_walking_animation.emit()
			return
		elif distance_to_player < MIN_DISTANCE:
			direction = -direction
	
	start_walking_animation.emit()
	accelerate_in_direction(direction)


func accelerate_in_direction(direction: Vector2):
	var desired_velocity = direction * max_speed
	velocity = velocity.lerp(desired_velocity, 1 - exp(-acceleration * get_process_delta_time()))

func decelerate():
	accelerate_in_direction(Vector2.ZERO)

func flip_enemy(sign: int):
	return sign
func move(character_body: CharacterBody2D):
	character_body.velocity = velocity
	character_body.move_and_slide()
	velocity = character_body.velocity
