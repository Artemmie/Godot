extends Node
class_name HealthComponent

signal died
signal health_changed

@export var max_health: float = 10

var current_health
var updated_health

func _ready():
	current_health = max_health
	updated_health = 0
	GameEvents.enemy_health_changed.connect(on_enemy_health_changed)

func damage(damage_amount: float):
	current_health = max(current_health - damage_amount, 0)
	print("current_health: " , current_health)
	health_changed.emit()
	Callable(check_death).call_deferred()
	
func get_health_percent():
	if max_health <= 0:
		return 0
	return min(current_health / max_health, 1)
	
func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()
		
func on_enemy_health_changed(multiplier: float):
	var enemy = get_parent()
	if enemy == null:
		return
	if enemy.is_in_group("enemy"):
		if updated_health >= max_health:
			print("skip")
			return
		max_health = max_health * multiplier
		current_health = max_health
		updated_health = max_health + 1
		print("current health: ", current_health)
