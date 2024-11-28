extends CharacterBody2D

@export var speed : float =  100.0
@export var player_hp : int = 80

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation : AnimationPlayer = $AnimationPlayer

# Attacks
var ice_spear = preload("res://Player/Attack/ice_spear.tscn")

# Attack Nodes
@onready var iceSpearTimer = get_node("%IceSpearTimer")
@onready var iceSpearAttackTimer = get_node("%IceSpearAttackTimer")

# IceSpear
var icespear_ammo = 0
var icespear_base_ammo = 100
var icespear_attack_speed = 1
var icespear_level = 1

# Enemy related
var enemy_close = []

func _ready() -> void:
	attack()


func attack():
	if icespear_level > 0:
		iceSpearTimer.wait_time = icespear_attack_speed
		if iceSpearTimer.is_stopped():
			iceSpearTimer.start()


func _physics_process(_delta: float) -> void:
	movement()
	move_and_slide()


func movement():
	# get the input direction
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x > 0:
		sprite.flip_h = true
		$CollisionShape2D.position.x = -1
		$Hurtbox/CollisionShape2D.position.x = -2
	elif direction.x < 0:
		sprite.flip_h = false
		$CollisionShape2D.position.x = 1
		$Hurtbox/CollisionShape2D.position.x = 0
		
	velocity = direction * speed
	if velocity.length() > 0:
		animation.play("walk")
	else:
		animation.pause()


func _on_hurtbox_hurt(damage: Variant) -> void:
	player_hp -= damage
	print("Player HP: ", player_hp)


func _on_ice_spear_timer_timeout() -> void:
	icespear_ammo += icespear_base_ammo
	iceSpearAttackTimer.start()


func _on_ice_spear_attack_timer_timeout() -> void:
	if icespear_ammo > 0:
		var icespear_attack = ice_spear.instantiate()
		icespear_attack.position = position
		icespear_attack.target = get_random_target()
		icespear_attack.level = icespear_level
		add_child(icespear_attack)
		icespear_ammo -= 1
		if icespear_ammo > 0:
			iceSpearAttackTimer.start()
		else:
			iceSpearAttackTimer.stop()

func get_random_target():
	if enemy_close.size() > 0:
		var rand_pick = enemy_close.pick_random()
		var enemy_position = rand_pick.global_position
		return enemy_position
	else:
		return Vector2.UP


func _on_enemy_detection_area_body_entered(body: Node2D) -> void:
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body: Node2D) -> void:
	if enemy_close.has(body):
		enemy_close.erase(body)
