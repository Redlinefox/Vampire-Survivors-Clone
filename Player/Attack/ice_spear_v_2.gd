extends Sprite2D

var level = 1
var damage = 1
var durability = 1
var speed = 100
var knockback_amount = 100
var attack_size = 1
var angle_to_enemy = Vector2.ZERO
var target_enemy = Vector2.ZERO


func _ready() -> void:
	angle_to_enemy = global_position.direction_to(target_enemy)
	rotation = angle_to_enemy.angle()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()


func _physics_process(delta: float) -> void:
	position = angle_to_enemy * speed * delta
	

func enemy_hit(charge = 1):
	durability -= charge
	if durability <= 0:
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
