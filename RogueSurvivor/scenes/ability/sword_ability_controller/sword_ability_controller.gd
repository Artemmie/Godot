extends Node

const MAX_RANGE = 150
@export var sword_ability: PackedScene
@export var base_damage = 5

var additional_damage_percent = 1
var base_damage_percent = 1
var base_wait_time
var swords_amount = 0

func _ready():
	base_wait_time = $Timer.wait_time
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
	initiate_sword_ability()
		
func initiate_sword_ability():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	if player.is_in_group("swordman"):
		swords_amount = 1
	
func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
		
	var enemies = get_tree().get_nodes_in_group("enemy")
	enemies = enemies.filter(func(enemy: Node2D): 
		return enemy.global_position.distance_squared_to(player.global_position) < pow(MAX_RANGE, 2))
	if (enemies.size() == 0):
		return
	
	enemies.sort_custom(func(a: Node2D, b:Node2D):
		var a_distance = a.global_position.distance_squared_to(player.global_position)
		var b_distance = b.global_position.distance_squared_to(player.global_position)
		return a_distance < b_distance)
	for i in range(0, swords_amount):
		if enemies.size() <= i:
			return
		var sword_instance = sword_ability.instantiate() as SwordAbility
		var foreground_layer = get_tree().get_first_node_in_group("foreground_layer")
		foreground_layer.add_child(sword_instance)
		sword_instance.hitbox_component.damage = (base_damage * base_damage_percent) * (additional_damage_percent)
		sword_instance.global_position = enemies[i].global_position
		sword_instance.global_position += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 4
		var enemy_direction = enemies[0].global_position - sword_instance.global_position
		sword_instance.rotation = enemy_direction.angle()

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if upgrade.id == "sword_rate":
		var percent_reduction = current_upgrades["sword_rate"]["quantity"] * 0.05
		$Timer.wait_time = max(base_wait_time * (1 - percent_reduction), 0.1)
		$Timer.start()
	elif upgrade.id == "sword_damage":
		additional_damage_percent = 1 + current_upgrades["sword_damage"]["quantity"] * 0.1
	elif upgrade.id == "sword":
		swords_amount = current_upgrades["sword"]["quantity"]
	elif upgrade.id == "sword_base_damage":
		base_damage_percent = 1 + current_upgrades["sword_base_damage"]["quantity"] * 0.1
	
