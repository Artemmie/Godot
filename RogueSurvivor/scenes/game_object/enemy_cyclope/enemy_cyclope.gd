extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent
@onready var health_component = $HealthComponent

var current_difficulty = 3

func _ready():
	$HurtBoxComponent.hit.connect(on_hit)
	GameEvents.enemy_health_changed.connect(on_difficulty_change)
func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign, 1)

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()

func on_difficulty_change(difficulty: int):
	if difficulty % current_difficulty >= 1:
		return
	print("current difficulty")
	print(current_difficulty)
	print("current max health")
	print(health_component.max_health)
	current_difficulty += current_difficulty
	health_component.max_health += health_component.max_health
	print("new difficulty")
	print(current_difficulty)
	print("new max health")
	print(health_component.max_health)
 
