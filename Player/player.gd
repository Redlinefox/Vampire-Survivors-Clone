extends CharacterBody2D

@export var speed : float =  100.0
@export var player_hp : int = 80

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation : AnimationPlayer = $AnimationPlayer



func _physics_process(_delta: float) -> void:
	movement()

	move_and_slide()


func movement():
	# get the input direction
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	
	if direction.x > 0:
		sprite.flip_h = true
	elif direction.x < 0:
		sprite.flip_h = false
		
	velocity = direction * speed
	if velocity.length() > 0:
		animation.play("walk")
	else:
		animation.pause()


func _on_hurtbox_hurt(damage: Variant) -> void:
	player_hp -= damage
	print("Player HP: ", player_hp)
