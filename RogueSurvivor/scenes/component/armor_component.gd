extends Node
class_name ArmorComponent

signal armor_changed

@export var max_armor = 0

func _ready():
	var player = get_parent() as CharacterBody2D
	if player == null:
		return
	calculate_base_armor(player)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)

func get_armor_value():
	return max_armor
	
func calculate_base_armor(player: CharacterBody2D):
	if player.is_in_group("swordman"):
		max_armor = 2

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade.id == "player_armor":
		max_armor = max_armor + (max_armor * current_upgrades["player_armor"]["quantity"] * 0.1)
	
