extends CharacterBody2D

@export var enemy_speed : float = 50.0
@export var enemy_hp : int = 10
@export var knockback_recovery = 3.5
var knockback = Vector2.ZERO


@onready var sprite : Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var sound_hit = $SoundHit

var death_animation = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _ready() -> void:
	animation.play("walk")


func _physics_process(_delta: float) -> void:
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_speed
	velocity += knockback
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	
	move_and_slide()


func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_animation.instantiate()
	enemy_death.scale = sprite.scale
	enemy_death.position = position
	get_parent().call_deferred("add_child", enemy_death)
	queue_free()

func _on_hurtbox_hurt(damage, angle, knockback_amount) -> void:
	enemy_hp -= damage
	knockback = angle * knockback_amount
	if enemy_hp <= 0:
		death()
	else:
		sound_hit.play()
