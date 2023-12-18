extends Node

@export var experience_manager: Node
@export var upgrade_screen_scene: PackedScene
@export var player: CharacterBody2D

var current_upgrades = {}
var upgrade_pool: WeightedTable = WeightedTable.new()

#axe
var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
#sword
var upgrade_sword = preload("res://resources/upgrades/sword.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
#common
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_pickup_distance = preload("res://resources/upgrades/pickup_distance.tres")
var upgrade_player_health = preload("res://resources/upgrades/player_health.tres")
var upgrade_player_armor = preload("res://resources/upgrades/player_armor.tres")
var upgrade_physical_base_damage = preload("res://resources/upgrades/physical_base_damage.tres")


func _ready():
	upgrade_pool.add_item(upgrade_sword, 3)
	upgrade_pool.add_item(upgrade_axe, 3)
	upgrade_pool.add_item(upgrade_player_speed, 5)
	upgrade_pool.add_item(upgrade_pickup_distance, 5)
	upgrade_pool.add_item(upgrade_player_health, 5)
	upgrade_pool.add_item(upgrade_player_armor, 5)
	if player.is_in_group("swordman"):
		apply_upgrade(upgrade_sword)
	experience_manager.level_up.connect(on_level_up)
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.id)
	if !has_upgrade:
		current_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		current_upgrades[upgrade.id]["quantity"] += 1
		
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade, current_upgrades)
		
func update_upgrade_pool(chosen_upgrade: AbilityUpgrade):
	if chosen_upgrade.id == upgrade_axe.id:
		upgrade_pool.add_item(upgrade_axe_damage, 10)
	if chosen_upgrade.id == upgrade_sword.id:
		upgrade_pool.add_item(upgrade_sword_rate, 10)
		upgrade_pool.add_item(upgrade_sword_damage, 10)
	check_base_damage(chosen_upgrade)

func check_base_damage(chosen_upgrade: AbilityUpgrade):
	if !current_upgrades.has(upgrade_physical_base_damage.id):
		if current_upgrades.has(upgrade_axe.id) or current_upgrades.has(upgrade_sword.id):
			upgrade_pool.add_item(upgrade_physical_base_damage, 5)
	

		
		
func pick_upgrades():
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 3:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	return chosen_upgrades
	
	
func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	
func on_level_up(current_level: int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
