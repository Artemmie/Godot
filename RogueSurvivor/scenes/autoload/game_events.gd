extends Node

signal experience_vial_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged
signal enemy_health_changed(number: float)

func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)

func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrades_added.emit(upgrade, current_upgrades)

func emit_player_damaged():
	player_damaged.emit()
	
func emit_enemy_health_changed(number: float):
	enemy_health_changed.emit(number)
	
