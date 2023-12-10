extends CharacterBody2D

@onready var velocity_component = $VelocityComponent
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var pickup_distance = $PickupArea2D/CollisionShape2D

var number_colliding_bodies = 0
var base_speed = 0
var base_pickup_radius = 0
var base_health = 0
var damage = 0

func _ready():
	base_speed = velocity_component.max_speed
	base_pickup_radius = pickup_distance.shape.radius
	base_health = health_component.max_health
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrades_added.connect(on_ability_upgrade_added)
	update_health_display()

func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
	var move_sign = sign(movement_vector.x)
	if move_sign != 0:
		visuals.scale= Vector2(move_sign, 1)
	
	
func get_movement_vector():
	return Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return 
	health_component.damage(damage)
	damage_interval_timer.start()
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()

func on_body_entered(other_body: Node2D):
	if other_body.is_in_group("cyclope"):
		damage = 1
	elif other_body.is_in_group("wizard"):
		damage = 2
	elif other_body.is_in_group("bat"):
		damage = 3
	number_colliding_bodies += 1
	check_deal_damage()
	
func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1

func on_damage_interval_timer_timeout():
	check_deal_damage()
	
func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()
	$HitRandomStreamPlayer.play_random()
	
func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"] * 0.05)
	elif ability_upgrade.id == "pickup_distance":
		pickup_distance.shape.radius = base_pickup_radius + (base_pickup_radius * current_upgrades["pickup_distance"]["quantity"] * .1)
	elif ability_upgrade.id == "player_health":
		health_component.current_health += health_component.max_health * .1
		health_component.max_health = base_health + (base_health * current_upgrades["player_health"]["quantity"] * .1)
