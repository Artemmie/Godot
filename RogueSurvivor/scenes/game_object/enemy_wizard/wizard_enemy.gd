extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var visuals = $Visuals
@onready var health_component = $HealthComponent
@onready var animation_player = $AnimationPlayer

var is_moving

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	velocity_component.stop_walking_animation.connect(on_stop_walking_animation)
	velocity_component.start_walking_animation.connect(on_walking_animation)
func _process(delta):
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	
	rotate_wizard(sign(velocity.x))

func rotate_wizard(move_sign: int):
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)
	
func set_is_moving(moving: bool):
	is_moving = moving

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()

func on_walking_animation():
	animation_player.play("walk")
func on_stop_walking_animation():
	animation_player.play("RESET")
