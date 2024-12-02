extends Area2D

@export_enum("Cooldown", "Hit_once", "Disable_hitbox") var HurtboxType = 0

@onready var collision = $CollisionShape2D
@onready var disableTimer = $DisableTimer

var hit_once_array = []

signal hurt(damage, angle, knockback)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("attack"):
		if not area.get("damage") == null:
			match HurtboxType:
				0: #Cooldown
					collision.call_deferred("set", "disabled", true)
					disableTimer.start()
				1: #HitOnce
					if hit_once_array.has(area) == false:
						hit_once_array.append(area)
						if area.has_signal("remove_from_array"):
							if not area.is_connected("remove_from_array", Callable(self, "remove_from_list")):
								area.connect("remove_from_array", Callable(self, "remove_from_list"))
					else:
						return
				2: #Disable Hitbox
					if area.has_method("tempdisable"):
						area.tempdisable()
			var damage = area.damage
			var angle = Vector2.ZERO
			var knockback = 1
			if not area.get("angle") == null:
				angle = area.angle
			if not area.get("knockback_amount") == null:
				knockback = area.knockback_amount
			
			emit_signal("hurt", damage, angle, knockback)
			if area.has_method("enemy_hit"):
				area.enemy_hit(1)


func _on_disable_timer_timeout() -> void:
	collision.call_deferred("set", "disabled", false)


func remove_from_list(object):
	if hit_once_array.has(object):
		hit_once_array.erase(Object)
