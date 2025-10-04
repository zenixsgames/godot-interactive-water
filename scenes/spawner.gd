extends Node2D


const RAINDROP : PackedScene = preload("uid://bn56jmbva76jg")
@onready var drop_timer: Timer = $drop_timer
@onready var SCREEN_SIZE : Vector2 = get_viewport().size


func _ready() -> void:
	drop_timer.wait_time = 0.1
	drop_timer.one_shot = true
	drop_timer.start()


func _on_drop_timer_timeout() -> void:
	var new_raindrop = RAINDROP.instantiate()
	new_raindrop.global_position = Vector2(randf_range(0.0, SCREEN_SIZE.x), -10)
	#new_raindrop.global_position = Vector2(500, -10)
	new_raindrop.gravity_scale = 2.0
	add_child(new_raindrop)
	drop_timer.start()
