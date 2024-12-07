extends Area2D

@export_range(1, 1000) var frequency := 8.0
@export_range(1, 1000) var amplitude := 100.0
@export_range(1, 1000) var initial_boost := 150
@export_range(0, 360) var wave_offset := 0.0
@export_range(1, 1000) var length_multiplier := 15.0
@export var num_of_points := 1200
@export var spawn_point := Vector2(50, 150)

@onready var player = get_tree().get_first_node_in_group("player")
@onready var timer = $Timer

var level = 1
var hp = 1
var speed = 100
var damage = 5
var knockback_amount = 100
var attack_size = 1.0
var last_movement = Vector2.ZERO

signal remove_from_array(object)

func _ready() -> void:
	#assert(timer.timeout.connect(_on_timer_timeout) == OK)
	match level:
		1:
			hp = 9999
			speed = 200.0
			damage = 5
			knockback_amount = 100
			attack_size = 1.0
	
	
	get_parent().rotation = last_movement.angle() # set the rotation of the parent to the player direction
	rotation -= last_movement.angle() # reset the rotation of the sprite irrespective of the parent
	pass


func _physics_process(delta: float) -> void:
	var timer += delta
	var movement = sin(timer * frequency + wave_offset) * ((amplitude * timer) + initial_boost)
	position.y += movement * delta
	position.x += speed * delta


func _on_timer_timeout() -> void:
	remove_from_array.emit(self)
	queue_free()
