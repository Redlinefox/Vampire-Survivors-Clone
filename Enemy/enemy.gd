extends CharacterBody2D

@export var enemy_speed : float = 50.0
@export var enemy_hp : int = 10

@onready var sprite : Sprite2D = $Sprite2D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation.play("walk")


func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * enemy_speed
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
	
	move_and_slide()


func _on_hurtbox_hurt(damage: Variant) -> void:
	enemy_hp -= damage
	print("Enemy HP: ", enemy_hp)
	if enemy_hp <= 0:
		queue_free()
