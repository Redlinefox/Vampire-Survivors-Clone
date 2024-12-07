extends Timer

var ice_spear = preload("res://Player/Attack/ice_spear_v_2.tscn")
var ammo = 1
var reload_amount = 1
var firerate := $Firerate

func _process(delta: float) -> void:
	if ammo > 0:
		
